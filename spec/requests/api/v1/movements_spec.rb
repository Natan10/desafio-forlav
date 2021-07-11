require "rails_helper"

RSpec.describe "AP1/V1/Movements", type: :request do
  describe "GET /balance" do
    let(:user) { create(:user, :with_balance) }

    it "return balance" do
      get "/api/movements/#{user.id}/balance"
      result = json_parse(response.body)
      expect(response).to have_http_status(200)
      expect(result["balance"]).to eq(user.current_balance.to_s)
    end

    it "user not found" do
      get "/api/movements/100/balance"
      result = json_parse(response.body)

      expect(result["error"]).to eq("Usuário não existe!")
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "POST /transaction" do
    it "return transaction" do
      user = create(:user)
      transaction = {
        wallet_id: user.wallet.id,
        status: "credit",
        value: "10"
      }

      post "/api/movements/transaction",
        params: {movement: transaction}

      result = json_parse(response.body)

      expect(response).to have_http_status(:created)
      expect(result["transaction"]["balance"]).to eq("10.0")
      expect(result["transaction"]["status"]).to eq(transaction[:status])
    end

    it "empty params" do
      user = create(:user)

      post "/api/movements/transaction",
        params: {movement: {}}
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it "invalid params" do
      user = create(:user)
      transaction = {
        wallet_id: user.wallet.id,
        status: "credit",
        value: ""
      }
      post "/api/movements/transaction",
        params: {movement: transaction}

      expect(response).to have_http_status(:unprocessable_entity)
    end

    it "invalid wallet" do
      user = create(:user)
      transaction = {
        wallet_id: "",
        status: "credit",
        value: ""
      }
      post "/api/movements/transaction",
        params: {movement: transaction}

      expect(response).to have_http_status(:not_found)
    end
  end

  describe "GET /entries" do
    it "return all list" do
      user = create(:user)
      list_transactions = create_list(:transaction, 3, wallet: user.wallet)
      params = {}
      get "/api/movements/#{user.id}/entries", params: params
      result = json_parse(response.body)["entries"]
      expect(result.count).to eq(3)
    end

    it "invalid user" do
      get "/api/movements/100/entries", params: {}
      expect(response).to have_http_status(:not_found)
    end
  end
end
