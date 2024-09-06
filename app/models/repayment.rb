class Repayment < ApplicationRecord
  belongs_to :bill
  belongs_to :user

  validates :payment_date, presence: true
  validates :payment_method, presence: true
  validates :bill, presence: true
  validates :user, presence: true
  validates :bill_id, uniqueness: true

  after_create :mark_bill_as_paid

  private

  def mark_bill_as_paid
    bill.pay!
  end
end
