module Tradify
  class Level
    getter? loaded
    getter? completed

    @screen : Screen

    INITIAL_BALANCE = 1000
    TARGET_PROFIT   =  100
    PRICE_DATA      = [50, 70, 90, 40, 60, 30, 80, 100, 130, 150, 130, 110, 100, 90, 110, 130, 120, 110, 90, 70, 50, 60, 50, 40, 50, 70, 60]

    def initialize(@game : Game)
      @loaded = false
      @account = Account.new(balance: INITIAL_BALANCE)
      @screen = Screen.new(
        game: @game,
        account: @account,
        price_data: PRICE_DATA
      )

      @completed = false
    end

    def load
    end

    def start
      # ran once the level is loaded, and first update and draw ran
      message = TypedMessage.new(["Welcome to Tradify.", "Try to make money by buying and selling!"])
      @game.show(message) unless Game::DEBUG
    end

    def draw
      @screen.draw
    end

    def update
      @screen.update

      if !completed? && target_reached?
        message = TypedMessage.new(["Congrats, you made a profit of $#{TARGET_PROFIT}!"])
        @game.show(message)
        @completed = true
      end

      return if loaded?

      start

      @loaded = true
    end

    def target_reached?
      @account.balance >= INITIAL_BALANCE + TARGET_PROFIT
    end
  end
end
