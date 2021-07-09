class DebitService
  attr_accessor :transaction, :errors, :wallet

  def initialize(transaction, wallet)
    @transaction = transaction
    @wallet = wallet
    @errors = []
  end

  def debit
    if @transaction.value <= @wallet.balance
      @wallet.balance -= @transaction.value
      ActiveRecord::Base.transaction do
        @wallet.save
        @transaction.save
      end
      return self
    end
    errors << "Saldo insuficiente!!!"
    self
  end
end
