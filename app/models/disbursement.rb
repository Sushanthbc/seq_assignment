class Disbursement < ApplicationRecord
  belongs_to :order
  validates_presence_of :fee_amount, :final_amount

  scope :joins_merchant_shopper, -> {
    joins(order: [:merchant, :shopper])
  }

  scope :by_start_end_date_time, -> (start_date_of_week, end_date_of_week) {
    where(created_at: [start_date_of_week..end_date_of_week])
  }

  scope :by_merchant_id, -> (merchant_id) {
    # Always use in conjunction with joins_merchant_shopper scope
    where(orders: {merchant_id: merchant_id}) if merchant_id.present?
  }
end