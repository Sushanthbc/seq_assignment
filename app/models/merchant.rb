class Merchant < ApplicationRecord
  has_many :orders
  has_many :shoppers, through: :orders
  validates_presence_of :email, :name
end
