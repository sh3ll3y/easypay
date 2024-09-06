
class PendingTransactionProcessorWorker
  include Sidekiq::Worker

  def perform
    Rails.logger.info "PendingTransactionProcessorWorker started at #{Time.now}"

    pending_transactions = Transaction.where(status: 'pending').where('created_at <= ?', 5.minutes.ago)
    Rails.logger.info "Fetched pending transactions: #{pending_transactions.length}"

    pending_transactions.find_each do |transaction|
      user = transaction.user

      outcome = rand < 0.5 ? 'success' : 'failed'

      ActiveRecord::Base.transaction do
        if outcome == 'success'
          transaction.update!(status: 'success')
          PaymentEventPublisher.publish(transaction.txn_id, transaction.amount, transaction.status, transaction.user_id, transaction.biller_id, transaction.mobile_number, transaction.plan, metadata = {})
          Rails.logger.info("Transaction #{transaction.txn_id} processed successfully by cron")
          
        else
          transaction.update!(status: 'failed')
          PaymentEventPublisher.publish(transaction.txn_id, transaction.amount, transaction.status, transaction.user_id, transaction.biller_id, transaction.mobile_number, transaction.plan, metadata = {})
          
          user.with_lock do
            user.credit += transaction.amount.to_f
            user.save!
          end
          Rails.logger.info("Transaction #{transaction.txn_id} failed by cron, credit refunded")
        end
      end
    end
  rescue StandardError => e
    Rails.logger.error "Error processing pending transactions: #{e.message}"
  end
end
