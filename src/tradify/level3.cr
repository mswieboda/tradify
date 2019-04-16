module Tradify
  class Level3 < Level2
    INITIAL_BALANCE = 500
    TARGET_PROFIT   = 300
    PRICE_DATA      = [70, 80, 50, 50, 80, 90, 80, 40, 20, 90, 90, 90, 90, 80, 10]

    def load(balance = INITIAL_BALANCE)
      super

      sell_button.enable
    end

    def start
      # ran once the level is loaded, and first update and draw ran
      @game.show(TypedMessage.new("Now you can short!")) unless Game::DEBUG
    end

    def buy_click_proc
      ->buy_click_level_3
    end

    def sell_click_proc
      ->sell_click_level_3
    end

    def buy_click_level_3
      buy(screen.price)

      if @account.open_trades?
        buy_button.disable
      end

      sell_button.enable

      if @account.open_buy_trades?
        sell_button.text = "Sell"
      else
        sell_button.text = "Short"
      end

      true
    end

    def short(price)
      @account.execute_trade(Trade.new(action: Action::Short, price: price))
    end

    def sell_click_level_3
      if sell_button.text == "Sell"
        sell(screen.price)
      else
        short(screen.price)
      end

      if @account.open_trades?
        sell_button.disable
      end

      buy_button.enable

      if @account.open_buy_trades?
        sell_button.text = "Sell"
      else
        sell_button.text = "Short"
      end

      true
    end

    def target_reached?
      !@account.open_trades? && @account.balance > INITIAL_BALANCE + TARGET_PROFIT
    end

    def target_reached_message
      "Congrats, you made a profit of over $#{TARGET_PROFIT}!"
    end
  end
end
