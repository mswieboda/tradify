module Tradify
  abstract class Level
    getter? loaded
    getter? completed
    delegate price, to: screen

    @screen : Screen | Nil

    INITIAL_BALANCE = 0
    TARGET_PROFIT   = 1
    PRICE_DATA      = [] of Int32

    def initialize(@game : Game)
      @loaded = false
      @account = Account.new(balance: INITIAL_BALANCE)
      @completed = false
      @screen = Screen.new(
        game: @game,
        account: @account,
        price_data: PRICE_DATA,
        level: self
      ).as(Screen)
    end

    def load
    end

    def screen
      @screen.as(Screen)
    end

    def start
      # ran once the level is loaded, and first update and draw ran
    end

    def draw
      screen.draw
    end

    def update
      screen.update

      if !completed? && target_reached?
        @game.show(TypedMessage.new(target_reached_message))
        @completed = true
      end

      return if loaded?

      start

      @loaded = true
    end

    def target_reached?
      !@account.open_trades? && @account.balance >= INITIAL_BALANCE + TARGET_PROFIT
    end

    def target_reached_message
      ""
    end
  end
end
