require 'test_helper'

class ShopperTest < ActiveSupport::TestCase
  test "with valid data it saves correctly" do
    shopper = Shopper.new(
      name: "Olive Thompson",
      email: "olive.thompson@not_gmail.com",
      nif: "411111111Z"
    )
    assert shopper.valid?
  end

  test "email and name missing" do
    shopper = Shopper.new(
      nif: "411111111Z"
    )
    refute shopper.valid?
    assert_equal "Email can't be blank and Name can't be blank", shopper.errors.full_messages.to_sentence
  end
end
