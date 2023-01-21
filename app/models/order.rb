class Order < ApplicationRecord
  belongs_to :shopper
  belongs_to :merchant
  has_one :disbursement
  validates_presence_of :amount
end
