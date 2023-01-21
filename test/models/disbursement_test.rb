require 'test_helper'

class DisbursementTest < ActiveSupport::TestCase
  test "with valid data saves correctly" do
    shopper = shoppers(:olive)
    merchant = merchants(:treutel)
    order = Order.create!(
      shopper: shopper,
      merchant: merchant,
      amount: 2000,
      completed_at: Time.now
    )
    disbursement = Disbursement.new(
      order: order,
      final_amount: 120,
      fee_amount: 10
    )
    assert disbursement.valid?
  end

  test "final amount and fee amount is missing" do
    shopper = shoppers(:olive)
    merchant = merchants(:treutel)
    order = Order.create!(
      shopper: shopper,
      merchant: merchant,
      amount: 2000,
      completed_at: Time.now
    )
    disbursement = Disbursement.new(
      order: order
    )
    refute disbursement.valid?
    assert_equal "Fee amount can't be blank and Final amount can't be blank", disbursement.errors.full_messages.to_sentence
  end
end
