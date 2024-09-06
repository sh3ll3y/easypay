
module Admin
  class DashboardController < AdminController
    def index
      @total_users = User.count
      @total_transactions = Transaction.where(status: 'success').count
      @total_transaction_value = Transaction.where(status: 'success').sum(:amount)
      
      @recent_transactions = Transaction.includes(:biller, :user).order(created_at: :desc).page(params[:page]).per(10)
    end
  end
end
