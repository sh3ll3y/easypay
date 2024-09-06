class Biller < ApplicationRecord
  validates :name, presence: true
  validates :biller_id, presence: true, uniqueness: true

  include SoftDeletable
  has_many :transactions
  after_commit :expire_cache

  private

  def expire_cache
    Rails.cache.delete("biller_#{id}")
    Rails.cache.delete("all_billers")
  end
end
