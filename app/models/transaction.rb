class Transaction < ApplicationRecord
  belongs_to :wallet

  enum status: [:credit, :debit]
end
