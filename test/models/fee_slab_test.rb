require 'test_helper'

class FeeSlabTest < ActiveSupport::TestCase
  test "fee value is returned based on range" do
    fee_slab = FeeSlab.compute_range(val: 50)
    assert_equal 0.01, fee_slab

    fee_slab = FeeSlab.compute_range(val: 200)
    assert_equal 0.0095, fee_slab

    fee_slab = FeeSlab.compute_range(val: 301)
    assert_equal 0.0085, fee_slab.to_f
  end

  test "value passed beyond the constraints" do
    fee_slab = FeeSlab.compute_range(val: -2)
    assert_nil fee_slab
  end
end
