
class BillsController < ApplicationController
  before_action :set_bill, only: [:show, :pay]

  def index
    @bills = current_user.bills.order(created_at: :desc).page(params[:page]).per(10)
  end

  def show
  end

  def generate
    @bill = Bill.generate_new_bill(current_user)
    if @bill.persisted?
      if @bill.bill_amount <= 0.0
        if @bill.pending?
          Repayment.create!(
            bill: @bill,
            user: current_user,
            payment_date: Date.current,
            payment_method: "UPI"
          )
        end
      end

      redirect_to bills_path, notice: 'New bill has been generated.'
    else
      redirect_to bills_path, alert: 'Failed to generate new bill.'
    end
  end

  def pay
    if @bill.pending?
      Repayment.create!(
        bill: @bill,
        user: current_user,
        payment_date: Date.current,
        payment_method: "UPI"
      )
      redirect_to @bill, notice: 'Bill has been paid.'
    else
      redirect_to @bill, alert: 'This bill cannot be paid.'
    end
  end

  private

  def set_bill
    @bill = current_user.bills.find(params[:id])
  end
end
