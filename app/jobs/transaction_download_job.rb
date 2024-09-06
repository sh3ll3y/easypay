require 'csv'
require 'aws-sdk-s3'

class TransactionDownloadJob < ApplicationJob
  queue_as :default

  def perform(download_id)
    download = Download.find(download_id)
    download.processing!
    begin
      user = download.user
      transactions = user.transactions.order(created_at: :desc)
      csv_data = generate_csv(transactions)
      file_name = "transactions_#{Time.now.to_i}.csv"
      s3_resource = initialize_s3_resource
      bucket_name = ENV['S3_BUCKET']
      Rails.logger.info("bucket_name: #{bucket_name}")

      if s3_resource.nil? || bucket_name.nil?
        raise "AWS S3 not properly configured"
      end

      bucket = s3_resource.bucket(bucket_name)
      obj = bucket.object("user_downloads/#{user.id}/#{file_name}")
      
      obj.put(body: csv_data)
      
      download.update!(status: :completed, file_url: obj.key)
    rescue Aws::S3::Errors::ServiceError => e
      download.failed!
      Rails.logger.error "AWS S3 error for download #{download_id}: #{e.message}"
      Rails.logger.error e.backtrace.join("\n")
    rescue StandardError => e
      download.failed!
      Rails.logger.error "Failed to process download #{download_id}: #{e.message}"
      Rails.logger.error e.backtrace.join("\n")
    end
  end

  private

  def generate_csv(transactions)
    CSV.generate do |csv|
      csv << ["Date", "Amount", "Status", "Biller", "Transaction ID"]
      transactions.each do |transaction|
        csv << [transaction.created_at, transaction.amount, transaction.status, transaction.biller.name, transaction.txn_id]
      end
    end
  end

  def initialize_s3_resource
    Aws::S3::Resource.new(
      region: ENV['AWS_REGION'],
      credentials: Aws::Credentials.new(
        ENV['AWS_ACCESS_KEY_ID'],
        ENV['AWS_SECRET_ACCESS_KEY']
      )
    )
  rescue Aws::Errors::MissingCredentialsError => e
    Rails.logger.error "AWS credentials missing: #{e.message}"
    nil
  rescue StandardError => e
    Rails.logger.error "Failed to initialize S3 resource: #{e.message}"
    nil
  end
end
