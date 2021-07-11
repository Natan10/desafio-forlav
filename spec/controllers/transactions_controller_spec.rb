require "rails_helper"

RSpec.describe TransactionsController, type: :controller do
  let(:manager) { create(:manager) }
  before do
    sign_in manager
  end

  describe "POST #create" do
    let(:user){ create(:user) }

    it "valid params" do
      params = {
        wallet_id: user.wallet.id,
        status: "credit",
        value: 15.0
      }
      post :create , params: {transaction: params}
      expect(flash[:success]).to eq("Crédito feito com sucesso!")
    end

    it "whitout value" do
      params = {
        wallet_id: user.wallet.id,
        status: "credit",
        value: nil
      }
      post :create , params: {transaction: params}
      
      expect(flash[:error]).to eq("Valor não pode ficar em branco!")
    end

    it "whitout balance" do
      wallet = create(:wallet, balance: 150)
      params ={ 
        wallet_id: wallet.id,
        status: "debit",
        value: 160
       }
      post :create , params: {transaction: params}
      expect(flash[:error]).to eq("Saldo insuficiente!!!")
    end
  end
end