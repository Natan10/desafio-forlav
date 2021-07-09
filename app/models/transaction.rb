class Transaction < ApplicationRecord
  belongs_to :wallet

  enum status: {credit: "0", debit: "1"}
end
