module Tradify
  class Level4 < Level
    INITIAL_BALANCE = 500
    TARGET_PROFIT   = 300
    PRICE_DATA      = [70, 80, 50, 50, 80, 90, 80, 40, 20, 90, 90, 90, 90, 80, 10]

    def load
      @account = Account.new(balance: INITIAL_BALANCE)
      @screen = Screen.new(
        game: @game,
        account: @account,
        price_data: PRICE_DATA,
        level: self
      )
      # def buy_sell_click
      #   if @buttons[0].text == "Buy"
      #     buy_click
      #     @buttons[0].text = "Sell" if @account.open_trades? && @level.number < 4

      #     if @level.number >= 4
      #       if @account.open_buy_trades?
      #         @buttons[1].text = "Sell"
      #       else
      #         @buttons[1].text = "Short"
      #       end
      #     end
      #   else
      #     sell_click

      #     @buttons[0].text = "Buy" if @level.number < 4
      #   end

      #   true
      # end

      # def buy_click
      #   price = @chart.price

      #   @account.execute_trade(Trade.new(action: Action::Buy, price: price))

      #   trade_executed(price)
      # end

      # def sell_click
      #   price = @chart.price

      #   @account.execute_trade(Trade.new(action: Action::Sell, price: price))

      #   trade_executed(price)
      # end

      # def short_click
      #   if @buttons[1].text == "Sell"
      #     sell_click
      #   else
      #     price = @chart.price

      #     @account.execute_trade(Trade.new(action: Action::Short, price: price))

      #     trade_executed(price)

      #     @buttons[1].disable if @level.number > 2 && @level.number <= 3 && @account.open_trades?
      #     @buttons[0].text = "Buy"
      #   end

      #   if @level.number >= 4
      #     if @account.open_buy_trades?
      #       @buttons[1].text = "Sell"
      #     else
      #       @buttons[1].text = "Short"
      #     end
      #   end

      #   true
      # end
    end

    def start
      # ran once the level is loaded, and first update and draw ran
      @game.show(TypedMessage.new("Now you can have more than one lot!")) unless Game::DEBUG
    end

    def target_reached?
      !@account.open_trades? && @account.balance > INITIAL_BALANCE + TARGET_PROFIT
    end

    def target_reached_message
      "Congrats, you made a profit of over $#{TARGET_PROFIT}!"
    end
  end
end
