module Tradify
  class Level1 < Level
    INITIAL_BALANCE = 1000
    TARGET_PROFIT   =  100
    PRICE_DATA      = [70, 50, 70, 90, 40, 20, 15, 30, 10, 20, 30, 40, 45, 30, 50, 70, 60, 80, 100, 130, 150, 190, 140, 130, 110, 100, 90, 110, 130, 120, 150, 140, 160, 100, 90, 110, 90, 70, 50, 60, 50, 40, 50, 70, 60]

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
      @game.show(TypedMessage.new(["Welcome to Tradify.", "Try to make money by buying and selling!"])) unless Game::DEBUG
    end

    def target_reached?
      !@account.open_trades? && @account.balance > INITIAL_BALANCE + TARGET_PROFIT
    end

    def target_reached_message
      "Congrats, you made a profit of over $#{TARGET_PROFIT}!"
    end
  end
end
