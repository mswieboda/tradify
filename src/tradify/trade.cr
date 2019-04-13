module Tradify
  class Trade
    property price : Int32
    property action : Action

    def initialize(@price, @action)
    end
  end
end
