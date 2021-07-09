module Api 
  module V1 
    class MovementsController < ApiController
      rescue_from ActiveRecord::RecordNotFound,with: :verify_user
    
      def balance
        @balance = set_user
        render :balance
      end

      private

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
