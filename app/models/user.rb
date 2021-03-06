class User < ApplicationRecord
  has_one :wallet, dependent: :destroy
  has_many :transactions, through: :wallet

  validates :email,
    presence: true,
    uniqueness: true,
    format: {with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i}
  validates :name, presence: true, uniqueness: true

  after_create :create_wallet

  def create_wallet
    Wallet.create!(user_id: id)
  end

  def current_balance
    wallet.balance
  end
end
