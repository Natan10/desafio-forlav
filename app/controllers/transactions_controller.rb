class TransactionsController < ApplicationController

  def create 
    @transaction = Transaction.new(transaction_params)
    @wallet = @transaction.wallet

    if @transaction.value.nil?
      flash[:error] = "Valor não pode ficar em branco"  
    else
      if @transaction.credit?
        @wallet.balance += @transaction.value 
        @wallet.save 
        @transaction.save 
        flash[:success]= "Crédito feito com sucesso!"
      else
        if @transaction.value <= @wallet.balance
          return if @transaction.value.nil?
          @wallet.balance -= @transaction.value
          @wallet.save
          @transaction.save
          flash[:success]= "Débito feito com sucesso!"
        elsif @transaction.value > @wallet.balance
          flash[:error]= "Saldo insuficiente!!!"
        end
      end
    end  
    redirect_to user_path(@wallet.user) 
  end

  private

  def transaction_params
    params.require(:transaction).permit(:wallet_id, :value,:status)
  end

end
