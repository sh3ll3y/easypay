class RepaymentsController < ApplicationController
  def index
    @repayments = current_user.repayments.includes(:bill).order(created_at: :desc).page(params[:page]).per(10)
  end

  def show
    @repayment = current_user.repayments.find(params[:id])
  end
end
