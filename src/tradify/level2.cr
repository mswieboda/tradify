module Tradify
  class Level2 < Level1
    INITIAL_BALANCE = 1000
    TARGET_PROFIT   =  500
    PRICE_DATA      = [300, 330, 350, 200, 220, 590, 680, 720, 200, 190, 200, 200, 200, 190, 130, 110, 110, 115, 115, 105, 100, 105, 100, 100, 135, 140, 140, 130, 120, 150, 155, 160, 180, 200, 220, 200]

    def load(balance = INITIAL_BALANCE)
      super
    end

    def load_buttons(side_panel_components)
      super

      sell_button.text = "Short"
      sell_button.remeasure
    end

    def start
      # ran once the level is loaded, and first update and draw ran
      @game.show(TypedMessage.new("Try to make money by buying and selling, with a different chart!")) unless Game::DEBUG
    end

    def update_buttons
      if price > @account.balance
        buy_button.disable

        if @account.open_trades?
          sell_button.text = "Sell"
          sell_button.enable
        else
          sell_button.text = "Short"
          sell_button.disable
        end
      else
        if @account.open_trades?
          buy_button.disable
          sell_button.text = "Sell"
          sell_button.enable
        else
          buy_button.enable
          sell_button.text = "Short"
          sell_button.disable
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
