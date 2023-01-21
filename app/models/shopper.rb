class Shopper < ApplicationRecord
  has_many :orders
  validates_presence_of :email, :name, :nif
end
