FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    name { Faker::Name.name }
    birthdate { Time.now }

    trait :with_balance do
      after(:create) do |user|
        user.wallet.update(balance: 1200)
      end
    end
  end
end
