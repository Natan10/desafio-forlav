require "rails_helper"

RSpec.describe User, type: :model do
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:email) }
  it { should validate_uniqueness_of(:email) }
  it { should have_one(:wallet) }

  describe "create user" do
    it "valid params" do
      user = build(:user)
      expect(user.save!).to be_truthy
    end

    it "whitout name" do
      user = build(:user, name: nil)
      expect(user.save).to be_falsey
    end

    it "whitout email" do
      user = build(:user, email: nil)
      expect(user.save).to be_falsey
    end
  end

  describe "update user" do
    let(:user) { create(:user) }
    it "valid params" do
      params = {
        name: "John doe"
      }

      expect(user.update(params)).to be_truthy
    end

    it "nil name" do
      params = {name: nil}
      expect(user.update(params)).to be_falsey
    end

    it "nil email" do
      params = {email: nil}
      expect(user.update(params)).to be_falsey
    end
  end

  describe "delete user" do
    let(:user) { create(:user) }
    it { expect(user.destroy).to be_truthy }
  end
end
