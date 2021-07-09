class CreditService
  attr_accessor :transaction, :errors, :wallet

  def initialize(transaction,wallet)
    @transaction = transaction
    @wallet = wallet
    @errors = []
  end

  def credit 
    @wallet.balance += transaction.value
    ActiveRecord::Base.transaction do
      @wallet.save
      @transaction.save
    end
    self
  end


end