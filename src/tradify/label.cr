require "./component"

module Tradify
  class Label < Component
    property text

    @color : LibRay::Color

    FONT_SIZE = 20
    SPACING   =  3
    PADDING   = 15

    DEFAULT_COLOR = LibRay::WHITE

    def initialize(x, y, @text : String)
      measure = LibRay.measure_text_ex(
        sprite_font: LibRay.get_default_font,
        text: @text,
        font_size: FONT_SIZE,
        spacing: SPACING
      )
      width = measure.x.round.to_i
      height = measure.y.round.to_i

      super(x, y, width, height)

      @color = DEFAULT_COLOR
    end

    def update(px, py)
    end

    def draw(px, py)
      LibRay.draw_text_ex(
        sprite_font: LibRay.get_default_font,
        text: @text,
        position: LibRay::Vector2.new(x: px + @x,
          y: py + @y + @height / 2
        ),
        font_size: FONT_SIZE,
        spacing: SPACING,
        color: @color
      )
    end
  end
end
