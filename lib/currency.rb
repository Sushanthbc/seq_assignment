class Currency
  class << self
    def multiple(*args, precision: 2)
      args.map { |val| BigDecimal(val) }.reduce(&:*).round(precision)
    end

    def add(*args, precision: 2)
      args.map { |val| BigDecimal(val) }.sum.round(precision)
    end
  end
end