module Tradify
  class Level
    getter? loaded

    @screen : Screen

    PRICE_DATA = [50, 70, 90, 40, 60, 30, 80, 100, 130, 150, 130, 110, 100, 90, 110, 130, 120, 110, 90, 70, 50, 60, 50, 40, 50, 70, 60]

    def initialize(@game : Game)
      @loaded = false
      @screen = Screen.new(@game)
    end

    def load
      @screen = Screen.new(
        game: @game,
        x: 0,
        y: 0,
        width: Game::SCREEN_WIDTH,
        height: Game::SCREEN_HEIGHT,
        price_data: PRICE_DATA
      )
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

      return if loaded?

      start

      @loaded = true
    end

    def complete?
      false
    end
  end
end
