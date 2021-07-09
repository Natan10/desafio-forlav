module Api 
  module V1 
    class MovementsController < ApiController
      
      def balance
        @balance = set_user.current_balance
        render :balance
      rescue ActiveRecord::RecordNotFound
        verify_user
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
        verify_wallet
      end

      def entries
        @entries = set_user.transactions
        .order(created_at: :desc)
        
        render :entries
      rescue ActiveRecord::RecordNotFound
        verify_user
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

      def set_user
        @user = User.find(params[:user_id])
      end
      
      def transaction_params
        params.require(:movement)
        .permit(:wallet_id, :value,:status)
      end

      
      def verify_user
        render json: {
          error: "Usuário não existe!"
        }, status: :not_found
      end

      def verify_wallet
        render json: {
          error: "Carteira não existe!"
        }, status: :not_found
      end
    end
  end
end
