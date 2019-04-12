module Tradify
  class Chart
    BACKGROUND_COLOR = LibRay::Color.new(r: 30, g: 30, b: 30, a: 0)
    LINE_COLOR       = LibRay::Color.new(r: 0, g: 255, b: 0, a: 30)

    GRID_SIZE      = 50
    GRID_THICKNESS =  1

    def initialize(@x : Int32, @y : Int32, @width : Int32, @height : Int32)
    end

    def initialize
      initialize(x: 0, y: 0, width: 0, height: 0)
    end

    def update
    end

    def draw
      draw_background
      draw_grid
    end

    def draw_background
      LibRay.draw_rectangle_v(
        position: LibRay::Vector2.new(x: @x, y: @y),
        size: LibRay::Vector2.new(x: @width, y: @height),
        color: BACKGROUND_COLOR
      )
    end

    def draw_grid
      # vertical
      ((@width / GRID_SIZE).round + 1).times do |grid_x|
        LibRay.draw_rectangle_v(
          position: LibRay::Vector2.new(
            x: @x + grid_x * GRID_SIZE,
            y: @y
          ),
          size: LibRay::Vector2.new(
            x: GRID_THICKNESS,
            y: @height
          ),
          color: LINE_COLOR
        )
      end

      # horizontal
      ((@height / GRID_SIZE).round + 1).times do |grid_y|
        LibRay.draw_rectangle_v(
          position: LibRay::Vector2.new(
            x: @x,
            y: @y + grid_y * GRID_SIZE
          ),
          size: LibRay::Vector2.new(
            x: @width,
            y: GRID_THICKNESS
          ),
          color: LINE_COLOR
        )
      end
    end
  end
end
