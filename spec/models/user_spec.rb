require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it { should validate_inclusion_of(:language).in_array(%w[en es]) }
  end

  describe 'associations' do
    it { should have_many(:downloads) }
    it { should have_many(:transactions) }
  end

  describe 'callbacks' do
    describe '#set_default_language' do
      it 'sets the default language to I18n.default_locale' do
        allow(I18n).to receive(:default_locale).and_return(:en)
        user = User.new
        expect(user.language).to eq('en')
      end

      it 'does not override existing language' do
        user = User.new(language: 'es')
        expect(user.language).to eq('es')
      end
    end

    describe '#assign_random_credit' do
      it 'assigns a random credit amount before create' do
        user = User.new(email: 'test@example.com', password: 'password')
        expect {
          user.save
        }.to change { user.credit }.from(0.0)
        expect(user.credit.to_f).to be_in([500.0, 1000.0, 5000.0, 1000000.0])
      end
    end
  end

  describe 'devise modules' do
    it { should have_db_column(:email).of_type(:string) }
    it { should have_db_column(:encrypted_password).of_type(:string) }
    it { should have_db_column(:reset_password_token).of_type(:string) }
    it { should have_db_column(:reset_password_sent_at).of_type(:datetime) }
    it { should have_db_column(:remember_created_at).of_type(:datetime) }
  end

  describe 'soft delete' do
    it { should have_db_column(:deleted_at).of_type(:datetime) }
    it { should have_db_index(:deleted_at) }

    it 'includes SoftDeletable module' do
      expect(User.included_modules).to include(SoftDeletable)
    end
  end

  describe 'additional attributes' do
    it { should have_db_column(:credit).of_type(:decimal).with_options(precision: 10, scale: 2, default: 0.0) }
    it { should have_db_column(:admin).of_type(:boolean).with_options(default: false) }
    it { should have_db_column(:language).of_type(:string) }
  end

  describe 'indexes' do
    it { should have_db_index(:email).unique }
    it { should have_db_index(:reset_password_token).unique }
  end
end
