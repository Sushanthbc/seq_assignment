module FeeSlabError
  class FeeSlabNotFound < StandardError
    def initialize(msg)
      @msg = msg
    end

    def message
      "Fee Slab not found: #{@msg}"
    end
  end
end