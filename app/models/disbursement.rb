class Disbursement < ApplicationRecord
  belongs_to :order
  validates_presence_of :fee_amount, :final_amount
end