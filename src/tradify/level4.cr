module Tradify
  class Level4 < Level3
    INITIAL_BALANCE = 500
    TARGET_PROFIT   = 300
    PRICE_DATA      = [70, 80, 50, 50, 80, 90, 80, 40, 20, 90, 90, 90, 90, 80, 10]

    def load(balance = INITIAL_BALANCE)
      super
    end

    def load_balance(side_panel_components)
      @balance_label = Label.new(0, 0, text: "$#{@account.balance}")
      @positions_label = Label.new(balance_label.width + Screen::PADDING, 0, text: "-1 $")

      side_panel_components << @positions_label.as(Component)
      side_panel_components << @balance_label.as(Component)
    end

    def start
      # ran once the level is loaded, and first update and draw ran
      @game.show(TypedMessage.new("Now you can have more than one lot!")) unless Game::DEBUG
    end

    def positions_label
      @positions_label.as(Label)
    end

    def update_account
      open_trades = @account.trades.select(&.open?)

      if open_trades.any?
        profit_and_loss = open_trades.sum(&.profit_and_loss(price))
        indicator = open_trades.select(&.buy?).any? ? "+" : "-"

        positions_label.text = "#{indicator}#{open_trades.size} $#{profit_and_loss}"
        positions_label.show

        balance_label.text = "$#{@account.balance + profit_and_loss}"
      else
        positions_label.hide

        balance_label.text = "$#{@account.balance}"
      end
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
