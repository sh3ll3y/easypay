# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
# db/seeds.rb

# Clear existing billers to avoid duplicates
Biller.destroy_all

billers = [
  {
    name: "Airtel",
    biller_id: "airtel_001",
    plans: {
      "199" => "1.5GB/Day, Unlimited Calls, 100 SMS/Day, Valid for 28 Days",
      "399" => "2GB/Day, Unlimited Calls, 100 SMS/Day, Valid for 56 Days",
      "599" => "2GB/Day, Unlimited Calls, 100 SMS/Day, Valid for 84 Days",
      "2999" => "2GB/Day, Unlimited Calls, 100 SMS/Day, Valid for 365 Days"
    }
  },
  {
    name: "BSNL",
    biller_id: "bsnl_001",
    plans: {
      "187" => "2GB/Day, Unlimited Calls, 100 SMS/Day, Valid for 28 Days",
      "399" => "1GB/Day, Unlimited Calls, 100 SMS/Day, Valid for 80 Days",
      "1999" => "3GB/Day, Unlimited Calls, 100 SMS/Day, Valid for 365 Days",
      "2399" => "3GB/Day, Unlimited Calls, 100 SMS/Day, Valid for 600 Days"
    }
  },
  {
    name: "Vodafone",
    biller_id: "vodafone_001",
    plans: {
      "219" => "1GB/Day, Unlimited Calls, 100 SMS/Day, Valid for 28 Days",
      "449" => "4GB/Day, Unlimited Calls, 100 SMS/Day, Valid for 56 Days",
      "699" => "4GB/Day, Unlimited Calls, 100 SMS/Day, Valid for 84 Days",
      "2899" => "1.5GB/Day, Unlimited Calls, 100 SMS/Day, Valid for 365 Days"
    }
  },
  {
    name: "Jio",
    biller_id: "jio_001",
    plans: {
      "199" => "1.5GB/Day, Unlimited Calls, 100 SMS/Day, Valid for 28 Days",
      "399" => "2GB/Day, Unlimited Calls, 100 SMS/Day, Valid for 56 Days",
      "599" => "2GB/Day, Unlimited Calls, 100 SMS/Day, Valid for 84 Days",
      "2879" => "2GB/Day, Unlimited Calls, 100 SMS/Day, Valid for 365 Days"
    }
  }
]

billers.each do |biller|
  Biller.create!(biller)
end

puts "Seed completed: #{Biller.count} billers created."
puts "Created billers: #{Biller.pluck(:name).join(', ')}"
