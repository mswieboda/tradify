module Tradify
  class Level
    getter? loaded

    @screen : Screen

    def initialize(@game : Game)
      @loaded = false
      @screen = Screen.new
    end

    def load
      @screen = Screen.new(
        x: 0,
        y: 0,
        width: Game::SCREEN_WIDTH,
        height: Game::SCREEN_HEIGHT
      )
    end

    def start
      # ran once the level is loaded, and first update and draw ran
      message = TypedMessage.new(["Welcome to Tradify.", "Try to make money by buying and selling!"])
      @game.show(message)
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