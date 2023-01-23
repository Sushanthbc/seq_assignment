require "test_helper"

module Disbursements
  class CreateServiceTest < ActiveSupport::TestCase
    test "Disbursement are processed successfully" do
      order = Order.create!(
        merchant: merchants(:treutel),
        shopper: shoppers(:olive),
        amount: 230,
        completed_at: Time.now.last_week.beginning_of_week + 1.day
      )
      result = Disbursements::CreateService.perform
      disbursement = Disbursement.find_by(order_id: order.id)
      assert result.success?
      assert_equal 2.19, disbursement.fee_amount
      assert_equal 232.19, disbursement.final_amount
    end

    test "No orders found for disbursement" do
      Order.create!(
        merchant: merchants(:treutel),
        shopper: shoppers(:olive),
        amount: 230,
      )
      result = Disbursements::CreateService.perform
      assert result.failure?
      assert "No orders found that are completed", result.failure
    end

    test "mixtures of both completed and not completed orders" do
      [{
         merchant: merchants(:treutel),
         shopper: shoppers(:olive),
         amount: 230
       }, {
        id: 2,
        merchant: merchants(:treutel),
        shopper: shoppers(:olive),
        amount: 232,
        completed_at: Time.now.last_week.end_of_week - 2.seconds
       }].each do |order|
        Order.create!(
          order
        )
      end
      order = Order.find(2)
      result = Disbursements::CreateService.perform
      disbursement = result.value!.first
      assert result.success?
      assert_equal 1, result.value!.count
      assert_equal order.id, disbursement.order.id
      assert_equal 2.20, disbursement.fee_amount
      assert_equal 234.20, disbursement.final_amount
    end

    test "Fee Slabs not found" do
      order = Order.create!(
        merchant: merchants(:treutel),
        shopper: shoppers(:olive),
        amount: -1,
        completed_at: Time.now.last_week.beginning_of_week + 1.day
      )
      result = Disbursements::CreateService.perform
      assert result.failure?
      assert_equal "Fee Slab not found: order Id: #{order.id}", result.failure
    end

    test "transactions rollback in case of error" do
      # wipe out all disbursements
      Disbursement.delete_all
      Order.create!(
        merchant: merchants(:treutel),
        shopper: shoppers(:olive),
        amount: 200,
        completed_at: Time.now.last_week.beginning_of_week + 1.day
      )
      Order.create!(
        merchant: merchants(:treutel),
        shopper: shoppers(:olive),
        amount: -1,
        completed_at: Time.now.last_week.beginning_of_week + 1.day
      )
      result = Disbursements::CreateService.perform
      assert result.failure?
      assert Disbursement.all.empty?
    end

    test "exclude if its already processed for week" do
      Order.create!(
        merchant: merchants(:treutel),
        shopper: shoppers(:olive),
        amount: 200,
        completed_at: Time.now.last_week.beginning_of_week + 1.day
      )
      Disbursements::CreateService.perform
      result = Disbursements::CreateService.perform

      assert result.success?
      assert result.value!.empty?
    end
  end
end