require "rails_helper"

RSpec.describe Transaction, type: :model do

  it { should validate_presence_of(:status) }
  it { should validate_presence_of(:value) }
  it { should validate_numericality_of(:value) }
  it { should belong_to(:wallet) }

  describe "create transaction" do
    it "valid params" do 
      transaction = build(:transaction)
      expect(transaction.save).to be_truthy
    end

    it "whitout status" do 
      transaction = build(:transaction, status: nil)
      expect(transaction.save).to be_falsey
    end

    it "whitout value" do
      transaction = build(:transaction, value: nil)
      expect(transaction.save).to be_falsey
    end

    it "wrong value" do
      transaction = build(:transaction,value: -1)
      expect(transaction.save).to be_falsey
    end
  end
end
