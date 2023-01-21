class Merchant < ApplicationRecord
  has_many :orders
  validates_presence_of :email, :name
end
