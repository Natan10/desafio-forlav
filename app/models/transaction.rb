class Transaction < ApplicationRecord
  belongs_to :wallet

  enum status: {credit: "0", debit: "1"}

  validates :value, presence: true,
  numericality: {greater_than_or_equal_to: 0,
                 less_than_or_equal_to: 100000}
  validates :status, presence: true

  scope :transaction_count, ->(type) { where(status: type).count }
  scope :transaction_value, ->(type) {
                              where(status: type)
                                .reduce(0) { |sum, obj| sum + obj.value }
                            }
  scope :all_transactions, -> { order(created_at: :desc) }
end
