class Transaction < ApplicationRecord

  belongs_to :user
  belongs_to :biller, -> { unscope(where: :deleted_at) }
  
  scope :search, ->(query) {
    joins(:biller)
      .where("transactions.mobile_number LIKE :query OR billers.name LIKE :query", query: "%#{query}%")
  }

  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks


  validates :txn_id, presence: true, uniqueness: true
  validates :mobile_number, presence: true
  validates :plan, presence: true
  validates :status, presence: true, inclusion: { in: %w[success pending failed] }
  validates :amount, presence: true, numericality: { greater_than: 0 }

  def as_indexed_json(options = {})
    self.as_json(
      only: [:id, :txn_id, :mobile_number, :amount, :status, :plan, :created_at],
      include: {
        biller: { only: [:name] } # Include biller name for search functionality
      }
    )
  end



end

