module Tradify
  class Level
    getter? loaded

    @screen : Screen

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
        height: Game::SCREEN_HEIGHT
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
