FactoryBot.define do
  factory :transaction do
    value { (rand * 1000).truncate(1) }
    status { [:credit, :debit].sample }
    wallet
  end
end
