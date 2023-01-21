require 'test_helper'

class MerchantTest < ActiveSupport::TestCase
  test "with valid data it saves correctly" do
    merchant = Merchant.new(
      name: "Treutel, Schumm and Fadel",
      email: "info@treutel-schumm-and-fadel.com",
      cif: "B611111111"
    )
    assert merchant.valid?
  end

  test "email and name missing" do
    merchant = Merchant.new(
      cif: "B611111111"
    )
    refute merchant.valid?
    assert_equal "Email can't be blank and Name can't be blank", merchant.errors.full_messages.to_sentence
  end
end
