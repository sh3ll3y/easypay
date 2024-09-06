class Download < ApplicationRecord
  belongs_to :user
  validates :status, presence: true
  validates :file_url, presence: true, if: -> { status == 'completed' }
  enum status: { pending: 0, processing: 1, completed: 2, failed: 3 }

  def full_url
    return nil unless completed? && file_url.present?

    s3_bucket = ENV['S3_BUCKET']
    s3_region = ENV['AWS_REGION']
    object_key = file_url  # This is now just the object key, not the full URL

    s3 = Aws::S3::Resource.new(
      region: s3_region,
      credentials: Aws::Credentials.new(
        ENV['AWS_ACCESS_KEY_ID'],
        ENV['AWS_SECRET_ACCESS_KEY']
      )
    )

    begin
      obj = s3.bucket(s3_bucket).object(object_key)
      obj.presigned_url(:get, expires_in: 3600) # URL will be valid for 1 hour
    rescue Aws::S3::Errors::ServiceError => e
      Rails.logger.error "S3 error: #{e.message}"
      nil
    end
  end
end
