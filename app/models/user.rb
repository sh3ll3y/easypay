class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  validates :language, inclusion: { in: %w(en es) }
  after_initialize :set_default_language, if: :new_record?

  include SoftDeletable
  has_many :downloads
  has_many :bills
  has_many :repayments

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :transactions

  before_create :assign_random_credit

  private

  def assign_random_credit
    credit_options = [1000000]
    self.credit = credit_options.sample
  end

  def set_default_language
    self.language ||= I18n.default_locale.to_s
  end

end

