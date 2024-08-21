FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    sequence(:nickname) { |n| "User #{n}" }
  end
end
