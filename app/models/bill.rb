class Bill < ApplicationRecord
  belongs_to :user
  has_one :repayment

  enum status: { pending: 'pending', paid: 'paid', expired: 'expired' }

  validates :bill_amount, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :bill_date, presence: true
  validates :due_date, presence: true
  validates :status, presence: true, inclusion: { in: statuses.keys }
  validates :user, presence: true

  before_validation :set_due_date, on: :create
  
  scope :outstanding, -> { where(status: ['pending', 'expired']) }

  def self.generate_new_bill(user)
    transaction do
      user.bills.pending.update_all(status: :expired)
      bill_amount = user.credit_limit - user.credit
      create!(
        user: user,
        bill_amount: bill_amount,
        bill_date: Date.current,
        status: :pending
      )
    end
  end

  def pay!
    transaction do
      update!(status: :paid, paid_at: Time.current)
      user.update!(credit: user.credit_limit)
    end
  end

  private

  def set_due_date
    self.due_date ||= bill_date + 15.days if bill_date
  end
end
