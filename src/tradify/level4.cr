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
