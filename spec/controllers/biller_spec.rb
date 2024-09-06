require 'rails_helper'

RSpec.describe BillersController, type: :controller do
  include Devise::Test::ControllerHelpers

  let(:user) { create(:user) }
  let(:biller) { create(:biller) }

  before do
    sign_in user
  end

  describe "GET #show" do
    context "when biller exists" do
      before do
        allow(Rails.cache).to receive(:fetch).and_return(biller)
      end

      it "returns a success response" do
        get :show, params: { id: biller.id }
        expect(response).to be_successful
      end

      it "renders the show template" do
        get :show, params: { id: biller.id }
        expect(response).to render_template(:show)
      end

      it "returns JSON when requested" do
        get :show, params: { id: biller.id }, format: :json
        expect(response.content_type).to include('application/json')
        expect(response.body).to eq(BillerBlueprint.render(biller))
      end
    end

    context "when biller does not exist" do
      before do
        allow(Rails.cache).to receive(:fetch).and_return(nil)
      end

      it "redirects to root_path for HTML request" do
        get :show, params: { id: 'non_existent' }
        expect(response).to redirect_to(root_path)
        expect(flash[:notice]).to eq('Biller not found')
      end

      it "returns a not found status for JSON request" do
        get :show, params: { id: 'non_existent' }, format: :json
        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)).to eq({ "error" => "Biller not found" })
      end
    end
  end

  describe "DELETE #destroy" do
    before do
      allow(Rails.cache).to receive(:fetch).and_return(biller)
    end

    it "soft deletes the biller" do
      expect(biller).to receive(:soft_delete)
      delete :destroy, params: { id: biller.id }
    end

    it "redirects to root_path" do
      delete :destroy, params: { id: biller.id }
      expect(response).to redirect_to(root_path)
    end

    it "sets a success notice" do
      delete :destroy, params: { id: biller.id }
      expect(flash[:notice]).to eq('Biller was successfully deleted.')
    end
  end

  describe "private #set_biller" do
    it "fetches biller from cache" do
      expect(Rails.cache).to receive(:fetch).with("biller_#{biller.id}", expires_in: 1.hour).and_return(biller)
      get :show, params: { id: biller.id }
    end

    it "finds biller by id if not in cache" do
      allow(Rails.cache).to receive(:fetch).and_yield
      expect(Biller).to receive(:find_by).with(id: biller.id.to_s).and_return(biller)
      get :show, params: { id: biller.id }
    end
  end
end
