module Tradify
  class Screen
    BACKGROUND_COLOR = LibRay::Color.new(r: 30, g: 30, b: 30, a: 0)

    MARGIN  = 50
    BORDER  =  3
    PADDING = 25

    @chart : Chart

    def initialize(@x : Int32, @y : Int32, @width : Int32, @height : Int32)
      @chart = Chart.new(
        x: MARGIN + BORDER + PADDING,
        y: MARGIN + BORDER + PADDING,
        width: @width - MARGIN * 2 - BORDER * 2 - PADDING * 2,
        height: @height - MARGIN * 2 - BORDER * 2 - PADDING * 2
      )
    end

    def initialize
      initialize(x: 0, y: 0, width: 0, height: 0)
    end

    def update
      @chart.update
    end

    def draw
      @chart.draw

      # TODO: draw border
    end
  end
end
