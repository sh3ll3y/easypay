
class TransactionProcessorJob < ApplicationJob
  queue_as :transactions

  def perform(transaction_id)
    Rails.logger.info "Starting to process transaction #{transaction_id}"

    transaction = Transaction.find(transaction_id)
    user = transaction.user
    
    # Simulate processing time
    sleep 5
    
    outcome = rand

    ActiveRecord::Base.transaction do
      if outcome < 0.8
        transaction.update!(status: 'success')
        PaymentEventPublisher.publish(transaction.txn_id, transaction.amount, transaction.status, transaction.user_id, transaction.biller_id, transaction.mobile_number, transaction.plan, metadata = {})
        NotificationEventPublisher.publish(transaction.txn_id, transaction.amount, transaction.status, transaction.user_id, transaction.biller_id, transaction.mobile_number, transaction.plan, metadata = {})

        Rails.logger.info("Transaction #{transaction.txn_id} processed successfully")
        
      elsif outcome < 0.9
        transaction.update!(status: 'failed')
        PaymentEventPublisher.publish(transaction.txn_id, transaction.amount, transaction.status, transaction.user_id, transaction.biller_id, transaction.mobile_number, transaction.plan, metadata = {})
        NotificationEventPublisher.publish(transaction.txn_id, transaction.amount, transaction.status, transaction.user_id, transaction.biller_id, transaction.mobile_number, transaction.plan, metadata = {})

        
        user.with_lock do
          user.credit += transaction.amount.to_f
          user.save!
        end
        Rails.logger.info("Transaction #{transaction.txn_id} failed, credit refunded")

      else
        PaymentEventPublisher.publish(transaction.txn_id, transaction.amount, transaction.status, transaction.user_id, transaction.biller_id, transaction.mobile_number, transaction.plan, metadata = {})
        Rails.logger.info("Transaction #{transaction.txn_id} remains pending")
      end
    end

    Rails.logger.info "Finished processing transaction #{transaction_id}"
  rescue StandardError => e
    Rails.logger.error "Error processing transaction #{transaction_id}: #{e.message}"
  end
end
