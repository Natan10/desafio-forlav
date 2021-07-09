class TransactionsController < ApplicationController
  def create
    @transaction = Transaction.new(transaction_params)
    @wallet = @transaction.wallet

    if @transaction.value.nil?
      flash[:error] = "Valor não pode ficar em branco"
    else
      @transaction.credit? ? credit : debit
    end
    redirect_to user_path(@wallet.user)
  end

  private

  def credit
    credit = CreditService.new(@transaction, @wallet).credit
    if credit.errors.empty?
      flash[:success] = "Crédito feito com sucesso!"
    else
      flash[:error] = "Erro ao creditar!!!"
    end
  end

  def debit
    debit = DebitService.new(@transaction, @wallet).debit
    if debit.errors.empty?
      flash[:success] = "Débito feito com sucesso!"
    else
      flash[:error] = debit.errors.first
    end
  end

  def transaction_params
    params.require(:transaction).permit(:wallet_id, :value, :status)
  end
end
