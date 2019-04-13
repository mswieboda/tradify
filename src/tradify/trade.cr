module Tradify
  class Trade
    getter price : Int32
    getter action : Action
    getter? open
    delegate buy?, to: @action
    delegate sell?, to: @action
    delegate short?, to: @action

    def initialize(@price, @action)
      @open = true
    end

    def closed?
      !open?
    end

    def close
      @open = false
    end

    def to_s(io : IO)
      text = "1 @ $#{price}"
      text = "-" + text if sell? || short?

      io << text
    end
  end
end
