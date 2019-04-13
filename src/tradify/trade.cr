module Tradify
  class Trade
    getter price : Int32
    getter action : Action
    getter? open
    delegate buy?, to: @action
    delegate sell?, to: @action

    def initialize(@price, @action)
      @open = true
    end

    def closed?
      !open?
    end

    def close
      @open = false
    end
  end
end
