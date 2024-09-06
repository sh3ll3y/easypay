FactoryBot.define do
  factory :transaction do
    association :user
    association :biller
    sequence(:txn_id) { |n| "TXN#{n}" }
    mobile_number { "1234567890" }
    plan do
      JSON.generate({
        "199" => "1.5GB/Day, Unlimited Calls, 100 SMS/Day, Valid for 28 Days",
        "399" => "2GB/Day, Unlimited Calls, 100 SMS/Day, Valid for 56 Days",
        "599" => "2GB/Day, Unlimited Calls, 100 SMS/Day, Valid for 84 Days",
        "2999" => "2GB/Day, Unlimited Calls, 100 SMS/Day, Valid for 365 Days"
      })
    end
    status { %w[success pending failed].sample }
    amount { 10.00 }
  end
end
