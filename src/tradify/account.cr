module Tradify
  class Account
    getter balance : Int32
    getter trades : Array(Trade)

    def initialize(@balance)
      @trades = [] of Trade
    end

    def execute_trade(trade)
      @trades << trade

      if trade.buy?
        @balance -= trade.price

        if last_sell
          last_sell.as(Trade).close
          trade.close
        end
      elsif trade.sell?
        @balance += trade.price

        if last_buy
          last_buy.as(Trade).close
          trade.close
        end
      end
    end

    def open_trades?
      @trades.select(&.open?).any?
    end

    def last_buy
      open_buys = @trades.select { |t| t.open? && t.buy? }
      open_buys.last if open_buys.any?
    end

    def last_sell
      open_sells = @trades.select { |t| t.open? && t.sell? }
      open_sells.last if open_sells.any?
    end
  end
end
