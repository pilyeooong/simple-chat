FactoryBot.define do
  factory :chat_room do
    sequence(:name) { |n| "#{n} name" }
    sequence(:description) { |n| "#{n} description" }
  end
end
