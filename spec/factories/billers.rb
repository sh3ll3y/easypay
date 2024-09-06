FactoryBot.define do
  factory :biller do
    name { "Test Biller" }
    sequence(:biller_id) { |n| "BILLER#{n.to_s.rjust(3, '0')}" }
    plans { { "basic": { "price": 10 }, "premium": { "price": 20 } } }

  end
end
