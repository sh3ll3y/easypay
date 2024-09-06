class TransactionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_biller, except: [:index]

  def index
    @transactions = current_user.transactions.includes(:biller, :user)
    @transactions = @transactions.search(params[:query]) if params[:query].present?
    @transactions = @transactions.order(created_at: :desc).page(params[:page]).per(10)

    respond_to do |format|
      format.html
      format.js { render partial: 'transactions_table', locals: { transactions: @transactions }, layout: false }
    end
  end


  def new
    @transaction = @biller.transactions.new
    @amount = params[:amount]
    @details = params[:details]
  end

  def create
    @transaction = @biller.transactions.new(transaction_params)
    @transaction.user = current_user
    @transaction.status = 'pending'
    @transaction.txn_id = generate_txn_id
    @amount = @transaction.amount
    @details = JSON.parse(@transaction.plan)['details']

    ActiveRecord::Base.transaction do
      current_user.with_lock do
        if @transaction.amount.to_f <= current_user.credit
          current_user.credit -= @transaction.amount.to_f
          if current_user.save && @transaction.save
            PaymentEventPublisher.publish(@transaction.txn_id, @amount, @transaction.status, @transaction.user_id, @transaction.biller_id, @transaction.mobile_number, @transaction.plan, metadata = {})
            TransactionProcessorJob.perform_later(@transaction.id)

            respond_to do |format|
              format.html { redirect_to biller_path(@biller), notice: "Transaction initiated. Transaction ID: #{@transaction.txn_id}" and return }
              format.json { render json: { message: "Transaction initiated", txn_id: @transaction.txn_id }, status: :created and return }
            end
          else
            raise ActiveRecord::Rollback
          end
        else
          respond_to do |format|
            format.html { flash.now[:alert] = 'Insufficient credits'; render :new and return }
            format.json { render json: { errors: ['Insufficient credits'] }, status: :unprocessable_entity and return }
          end
        end
      end
    end

    respond_to do |format|
      format.html { flash.now[:alert] = @transaction.errors.full_messages.join(', '); render :new and return }
      format.json { render json: { errors: @transaction.errors.full_messages }, status: :unprocessable_entity and return }
    end
  end

  private
  
  def search_transactions(query)
    current_user.transactions.includes(:biller, :user).search(query)
  end

  def set_biller
    @biller = Biller.unscoped.find(params[:biller_id])
  end

  def transaction_params
    params.require(:transaction).permit(:mobile_number, :amount, :plan)
  end

  def random_status
    ['success', 'failed', 'pending'].sample
  end

  def search_transactions(query)
    Transaction.search({
      query: {
        multi_match: {
          query: query,
          fields: ['mobile_number', 'biller.name']
        }
      }
    }).records
  end

  def generate_txn_id
    "TXN#{Time.now.to_i}#{SecureRandom.hex(4)}".upcase
  end

  def my_transactions
    @transactions = current_user.transactions.includes(:biller, :user)
    @transactions = @transactions.search(params[:query]) if params[:query].present?
    @transactions = @transactions.order(created_at: :desc).page(params[:page]).per(10)

    respond_to do |format|
      format.html
      format.js { render partial: 'transactions_table', locals: { transactions: @transactions }, layout: false }
    end
  end

end

