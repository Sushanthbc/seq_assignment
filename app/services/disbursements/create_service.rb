module Disbursements
  class CreateService < ApplicationService
    include Dry::Monads[:result, :maybe]

    def perform
      completed_orders.bind do |orders|
        process_disbursement(orders)
      end
    end

    private

    FEE_SLAB_NOT_FOUND  = "fee_slab_not_found"

    def process_disbursement(orders)
      disbursements = []
      Disbursement.transaction do
        orders.each do |order|
          fee_slab = Maybe(FeeSlab.compute_range(val: order.amount)).value_or(FEE_SLAB_NOT_FOUND)
          raise FeeSlabError::FeeSlabNotFound.new("order Id: #{order.id}") if fee_slab == FEE_SLAB_NOT_FOUND

          fee_amount = ::Currency.multiple(order.amount, fee_slab)
          final_amount = ::Currency.add(order.amount, fee_amount)
          disbursement = Disbursement.new(
            order: order,
            fee_amount: fee_amount,
            final_amount: final_amount
          )
          disbursement.save!
          disbursements << disbursement
        end
      end
      Success(disbursements)
    rescue FeeSlabError::FeeSlabNotFound => e
      Rails.logger.fatal { "Disbursements::CreateService: Failed to fetch slab #{e}" }
      Failure(e.message)
    rescue ActiveRecord::ActiveRecordError => e
      # Setup application monitoring to catch service specific issues
      Rails.logger.fatal { "Disbursements::CreateService: Failed to save order: #{e.message}"}
      Failure("Failed to submit order: #{e.message}")
    end

    def completed_orders
      start_of_previous_week = Time.now.last_week.beginning_of_week
      end_of_previous_week = Time.now.last_week.end_of_week
      completed_orders = Order.where(
        completed_at: [start_of_previous_week..end_of_previous_week]
      )
      if completed_orders.empty?
        Failure("No orders found that are completed")
      else
        Success(completed_orders)
      end
    end
  end
end