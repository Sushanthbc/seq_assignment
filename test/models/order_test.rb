require 'test_helper'

class OrderTest < ActiveSupport::TestCase
  test "valid data order is persisted to db" do
    shopper = shoppers(:olive)
    merchant = merchants(:treutel)
    order = Order.new(
      shopper: shopper,
      merchant: merchant,
      amount: 2000,
      completed_at: Time.now
    )
    assert order.valid?
  end

  test "shopper reference and amount is missing" do
    merchant = merchants(:treutel)
    order = Order.new(
      merchant: merchant,
      completed_at: Time.now
    )
    refute order.valid?
    assert_equal "Shopper must exist and Amount can't be blank", order.errors.full_messages.to_sentence
  end
end
