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
        if first_sell_or_short
          first = first_sell_or_short.as(Trade)
          first.close
          trade.close

          if first.short?
            @balance += (first.price - trade.price)
            return
          end
        end

        @balance -= trade.price
      elsif trade.sell?
        @balance += trade.price

        if first_buy
          first_buy.as(Trade).close
          trade.close
        end
      elsif trade.short?
        if first_buy
          first_buy.as(Trade).close
          trade.close
        end
      end
    end

    def open_trades?
      @trades.select(&.open?).any?
    end

    def open_buy_trades?
      @trades.select { |t| t.open? && t.buy? }.any?
    end

    def first_buy
      open_buys = @trades.select { |t| t.open? && t.buy? }
      open_buys.first if open_buys.any?
    end

    def first_sell_or_short
      open_sell_or_shorts = @trades.select { |t| t.open? && (t.sell? || t.short?) }
      open_sell_or_shorts.first if open_sell_or_shorts.any?
    end
  end
end
