require 'rails_helper'

RSpec.describe Biller, type: :model do

  describe 'scopes and class methods' do
    let!(:existing_billers) { Biller.all.to_a }
    let!(:new_biller1) { Biller.create(name: 'New Biller 1', biller_id: "new_test_001_#{Time.now.to_i}") }
    let!(:new_biller2) { Biller.create(name: 'New Biller 2', biller_id: "new_test_002_#{Time.now.to_i}") }
    let!(:new_biller3) { Biller.create(name: 'New Biller 3', biller_id: "new_test_003_#{Time.now.to_i}") }

    after do
      [new_biller1, new_biller2, new_biller3].each(&:destroy)
    end

    it 'returns all billers including newly created ones' do
      expect(Biller.all).to include(new_biller1, new_biller2, new_biller3)
      existing_billers.each do |biller|
        expect(Biller.all).to include(biller)
      end
    end

    it 'returns new billers in order of creation' do
      new_billers = [new_biller1, new_biller2, new_biller3]
      expect(Biller.where(id: new_billers.map(&:id)).order(:created_at)).to eq(new_billers)
    end

    it 'can find a biller by biller_id' do
      expect(Biller.find_by(biller_id: new_biller1.biller_id)).to eq(new_biller1)
    end
  end
end
