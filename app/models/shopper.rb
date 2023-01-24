class Shopper < ApplicationRecord
  has_many :orders
  has_many :merchants, through: :orders
  validates_presence_of :email, :name, :nif
end
