require "csv"

task :load_test_data => :environment do
  puts "Started copying data to db ..."
  # load merchants
  merchants = CSV.read("./lib/csv/merchants.csv", headers: true)
  merchants.each do |merchant|
    Merchant.create!(
      id: merchant["id"],
      name: merchant["name"],
      email: merchant["email"],
      cif: merchant["cif"]
    )
  end

  # load shoppers
  shoppers = CSV.read("./lib/csv/shoppers.csv", headers: true)
  shoppers.each do |shopper|
    Shopper.create!(
      id: shopper["id"],
      name: shopper["name"],
      email: shopper["email"],
      nif: shopper["nif"]
    )
  end

  #load orders
  orders = CSV.read("./lib/csv/orders.csv", headers: true)
  orders.each do |order|
    Order.create!(
      id: order["id"],
      merchant_id: order["merchant_id"],
      shopper_id: order["shopper_id"],
      amount: order["amount"],
      completed_at: order["completed_at"]
    )
  end

  puts "Finished copying data to db ..."
end