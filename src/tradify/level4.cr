module Tradify
  class Level4 < Level3
    INITIAL_BALANCE = 500
    TARGET_PROFIT   = 300
    PRICE_DATA      = [70, 80, 50, 50, 80, 90, 80, 40, 20, 90, 90, 90, 90, 80, 10]

    def load(balance = INITIAL_BALANCE)
      super
    end

    def start
      # ran once the level is loaded, and first update and draw ran
      @game.show(TypedMessage.new("Now you can have more than one lot!")) unless Game::DEBUG
    end

    def update_buttons
      if price > @account.balance
        buy_button.disable

        if @account.open_buy_trades?
          sell_button.text = "Sell"
        else
          sell_button.text = "Short"
        end
      else
        buy_button.enable

        if @account.open_buy_trades?
          sell_button.text = "Sell"
        else
          sell_button.text = "Short"
        end
      end
    end

    def target_reached?
      !@account.open_trades? && @account.balance > INITIAL_BALANCE + TARGET_PROFIT
    end

    def target_reached_message
      "Congrats, you made a profit of over $#{TARGET_PROFIT}!"
    end
  end
end
