class BillersController < ApplicationController
  before_action :set_biller, only: [:show, :destroy]

  def show
    respond_to do |format|
      format.html
      format.json { render json: BillerBlueprint.render(@biller) }
    end
  end

  def destroy
    @biller.soft_delete # Soft delete the biller
    Rails.cache.delete("biller_#{params[:id]}") # Remove the biller from cache
    redirect_to root_path, notice: 'Biller was successfully deleted.'
  end

  private

  def set_biller
    @biller = Rails.cache.fetch("biller_#{params[:id]}", expires_in: 1.hour) do
      Biller.find_by(id: params[:id])
    end

    unless @biller
      respond_to do |format|
        format.html { redirect_to root_path, notice: 'Biller not found' }
        format.json { render json: { error: 'Biller not found' }, status: :not_found }
      end
    end
  end
end
