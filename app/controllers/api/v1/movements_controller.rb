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
          render json: {error: "Valor incorreto!!!"}, status: :unprocessable_entity
          return
        end
        @transaction.credit? ? credit : debit
        render :transaction, status: :created
      rescue ActiveRecord::RecordNotFound
        verify_wallet
      rescue ActionController::ParameterMissing
        verify_params
      end

      def entries
        @entries = if check_dates.nil?
          set_user.transactions.all_transactions
        else
          set_user.transactions
            .where(created_at: check_dates)
            .order(created_at: :desc)
        end
        render :entries
      rescue ActiveRecord::RecordNotFound
        verify_user
      end

      private

      def check_dates
        return nil if params[:start_date].nil? && params[:end_date].nil?
        return params[:end_date] if params[:start_date].nil?
        return (params[:start_date]..) if params[:end_date].nil?

        params[:start_date]..params[:end_date]
      end

      def credit
        @result = CreditService.new(@transaction, @wallet).credit
        @result
      end

      def debit
        @result = DebitService.new(@transaction, @wallet).debit
        @result
      end

      def check_date
      end

      def set_wallet
        if params[:movement].nil?
          raise ActionController::ParameterMissing.new("Parâmetros inválidos")
        end
        @wallet = Wallet.find(params[:movement][:wallet_id])
      end

      def set_user
        @user = User.find(params[:user_id])
      end

      def transaction_params
        params.require(:movement)
          .permit(:wallet_id, :value, :status)
      end

      def verify_params
        render json: {
          error: "Parâmetros inválidos!"
        }, status: :unprocessable_entity
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
