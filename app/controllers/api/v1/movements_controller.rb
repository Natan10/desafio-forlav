module Api 
  module V1 
    class MovementsController < ApiController
     
      def balance
        @balance = set_user
        render :balance
      rescue ActiveRecord::RecordNotFound
        render json: {
          error: "Usuário não existe!"
        }, status: :not_found
      end

      def transaction 
        @wallet = set_wallet
        @transaction = Transaction.new(transaction_params)
        if @transaction.value.nil?
          render json: { error: "Valor incorreto!!!" } , status: :unprocessable_entity
          return
        end
        @transaction.credit? ? credit : debit
        render :transaction, status: :created

      rescue ActiveRecord::RecordNotFound
        render json: {
          error: "Carteira não existe!"
        }, status: :not_found
      end

      private

      def credit 
        @result = CreditService.new(@transaction,@wallet).credit
        @result 
      end
    
      def debit
        @result = DebitService.new(@transaction,@wallet).debit
        @result
      end

      def set_wallet
        @wallet = Wallet.find(params[:wallet_id])
      end
      
      def transaction_params
        params.require(:movement)
        .permit(:wallet_id, :value,:status)
      end

      def set_user
        User.find(params[:user_id]).current_balance
      end

      def verify_user(e)
        render json: {
          error: "Usuário não existe!"
        }, status: :not_found
      end
    end
  end
end
