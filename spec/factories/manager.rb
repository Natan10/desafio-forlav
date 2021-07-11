FactoryBot.define do
  factory :manager do
    email { Faker::Internet.email }
    password { "123456" }
    password_confirmation {"123456"}
  end
end
