class Transaction < ApplicationRecord
  belongs_to :wallet

  enum status: {credit: "0", debit: "1"}

  scope :transaction_count, ->(type) { where(status: type).count }
  scope :transaction_value, ->(type) {
                              where(status: type)
                                .reduce(0) { |sum, obj| sum + obj.value }
                            }
end
