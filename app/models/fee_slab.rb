class FeeSlab < ApplicationRecord
  validates_presence_of :value, :higher_range, :lower_range

  class << self
    def compute_range(val:)
      find_by("lower_range < ? and higher_range >= ?", val, val)&.value
    end
  end
end
