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
        if last_sell_or_short
          last = last_sell_or_short.as(Trade)
          last.close
          trade.close

          if last.short?
            @balance += (last.price - trade.price) + last.price
            return
          end
        end

        @balance -= trade.price
      elsif trade.sell?
        @balance += trade.price

        if last_buy
          last_buy.as(Trade).close
          trade.close
        end
      elsif trade.short?
        @balance -= trade.price

        if last_buy
          last_buy.as(Trade).close
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

    def last_buy
      open_buys = @trades.select { |t| t.open? && t.buy? }
      open_buys.last if open_buys.any?
    end

    def last_sell_or_short
      open_sell_or_shorts = @trades.select { |t| t.open? && (t.sell? || t.short?) }
      open_sell_or_shorts.last if open_sell_or_shorts.any?
    end
  end
end
