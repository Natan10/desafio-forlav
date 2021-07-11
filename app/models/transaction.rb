class Transaction < ApplicationRecord
  belongs_to :wallet

  enum status: {credit: "0", debit: "1"}

  validates :value, numericality: true
  validates :status, presence: true
  

  scope :transaction_count, ->(type) { where(status: type).count }
  scope :transaction_value, ->(type) {
                              where(status: type)
                                .reduce(0) { |sum, obj| sum + obj.value }
                            }
  scope :all_transactions, -> {order(created_at: :desc)}
end
