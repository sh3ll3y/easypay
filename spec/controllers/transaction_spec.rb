require 'rails_helper'

RSpec.describe Transaction, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:biller) }

    it 'belongs to biller without considering deleted_at' do
      biller = create(:biller, deleted_at: Time.current)
      transaction = build(:transaction, biller: biller)
      expect(transaction).to be_valid
    end
  end

  describe 'validations' do
    subject { build(:transaction) }

    it { should validate_presence_of(:txn_id) }
    it { should validate_uniqueness_of(:txn_id).case_insensitive }
    it { should validate_presence_of(:mobile_number) }
    it { should validate_presence_of(:plan) }
    it { should validate_presence_of(:status) }
    it { should validate_inclusion_of(:status).in_array(%w[success pending failed]) }
    it { should validate_presence_of(:amount) }
    it { should validate_numericality_of(:amount).is_greater_than(0) }
  end

  describe 'database columns' do
    it { should have_db_column(:txn_id).of_type(:string).with_options(null: false) }
    it { should have_db_column(:user_id).of_type(:integer).with_options(null: false) }
    it { should have_db_column(:biller_id).of_type(:integer).with_options(null: false) }
    it { should have_db_column(:mobile_number).of_type(:string).with_options(null: false) }
    it { should have_db_column(:plan).of_type(:json).with_options(null: false) }
    it { should have_db_column(:status).of_type(:string).with_options(null: false) }
    it { should have_db_column(:amount).of_type(:decimal).with_options(null: false, precision: 10, scale: 2) }
    it { should have_db_column(:created_at).of_type(:datetime).with_options(null: false) }
    it { should have_db_column(:updated_at).of_type(:datetime).with_options(null: false) }
  end

  describe 'indexes' do
    it { should have_db_index(:biller_id) }
    it { should have_db_index(:status) }
    it { should have_db_index(:txn_id).unique(true) }
    it { should have_db_index(:user_id) }
  end

  describe 'factory' do
    it 'has a valid factory' do
      expect(build(:transaction)).to be_valid
    end
  end

  describe 'status' do
    let(:transaction) { create(:transaction) }

    it 'can be set to success' do
      transaction.status = 'success'
      expect(transaction).to be_valid
    end

    it 'can be set to pending' do
      transaction.status = 'pending'
      expect(transaction).to be_valid
    end

    it 'can be set to failed' do
      transaction.status = 'failed'
      expect(transaction).to be_valid
    end

    it 'cannot be set to an invalid status' do
      transaction.status = 'invalid'
      expect(transaction).to be_invalid
    end
  end
end
