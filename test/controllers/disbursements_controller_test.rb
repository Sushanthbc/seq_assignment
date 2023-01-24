require "test_helper"

class DisbursementControllerTest < ActionDispatch::IntegrationTest
  test "query parms with start date of week and merchant Id" do
    merchant = merchants(:treutel)
    order = Order.create!(
      merchant: merchant,
      shopper: shoppers(:olive),
      amount: 200,
      completed_at: Time.now.last_week.beginning_of_week + 1.day
    )
    Disbursements::CreateService.perform
    get api_disbursements_path, params: {
      start_date_of_week: Date.today.to_s,
      merchant: merchant.id
    }
    disbursement = JSON.parse(response.body).first
    assert_response :success
    assert_equal 1.9, disbursement["fee_amount"].to_d
    assert_equal 201.9, disbursement["final_amount"].to_d
    assert_equal merchant.name, disbursement["merchant_name"]
    assert_equal order.shopper.name, disbursement["shopper_name"]
  end

  test "returns all merchants without merchant Id in query params" do
    Order.create!(
      merchant: merchants(:treutel),
      shopper: shoppers(:olive),
      amount: 200,
      completed_at: Time.now.last_week.beginning_of_week + 1.day
    )
    Order.create!(
      merchant: merchants(:schoen),
      shopper: shoppers(:olive),
      amount: 200,
      completed_at: Time.now.last_week.beginning_of_week + 1.day
    )
    Disbursements::CreateService.perform
    get api_disbursements_path, params: {
      start_date_of_week: Date.today.to_s
    }
    disbursements = JSON.parse(response.body)
    assert_response :success
    assert_equal 2, disbursements.count
    assert_equal ["Schoen Inc", "Treutel, Schumm and Fadel"], disbursements.pluck("merchant_name").sort
  end

  test "start date of week is missing" do
    Order.create!(
      merchant: merchants(:treutel),
      shopper: shoppers(:olive),
      amount: 200,
      completed_at: Time.now.last_week.beginning_of_week + 1.day
    )
    Disbursements::CreateService.perform
    get api_disbursements_path, params: {
      merchant_id: merchants(:treutel).id
    }
    assert_response :bad_request
    assert_equal "start_date_of_week is missing", JSON.parse(response.body)["message"]
  end

  test "returns empty if no disbursements for start date week" do
    Order.create!(
      merchant: merchants(:treutel),
      shopper: shoppers(:olive),
      amount: 200,
      completed_at: Time.now.last_week.beginning_of_week + 1.day
    )
    Disbursements::CreateService.perform
    get api_disbursements_path, params: {
      start_date_of_week: (Date.today - 10.days).to_s
    }
    assert_response :success
    assert JSON.parse(response.body).empty?
  end
end