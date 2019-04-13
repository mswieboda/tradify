require "./component"

module Tradify
  class Button < Component
    getter? disabled
    getter padding : Int32
    property text

    @color : LibRay::Color
    @measure : LibRay::Vector2

    FONT_SIZE = 20
    SPACING   =  3
    PADDING   = 15

    DEFAULT_COLOR  = LibRay::WHITE
    DISABLED_COLOR = LibRay::Color.new(r: 70, g: 70, b: 70, a: 255)
    HOVER_COLOR    = LibRay::GREEN

    def initialize(@game : Game, x, y, @text : String, @click : Proc(Bool), @padding = PADDING)
      @measure = LibRay.measure_text_ex(
        sprite_font: LibRay.get_default_font,
        text: @text,
        font_size: FONT_SIZE,
        spacing: SPACING
      )
      width = @measure.x.round.to_i + @padding * 2
      height = @measure.y.round.to_i + @padding * 2

      super(x, y, width, height)

      @color = DEFAULT_COLOR
      @disabled = false
    end

    def disable
      @disabled = true
      @color = DISABLED_COLOR
    end

    def enable
      @disabled = false
      @color = DEFAULT_COLOR
    end

    def enabled?
      !disabled?
    end

    def update
      return if disabled?

      mouse = LibRay.get_mouse_position

      if over?(mouse)
        @color = HOVER_COLOR

        click if LibRay.mouse_button_pressed?(LibRay::MOUSE_LEFT_BUTTON)
      else
        @color = DEFAULT_COLOR
      end
    end

    def over?(mouse)
      mouse.x >= @x && mouse.x <= @x + width &&
        mouse.y >= @y && mouse.y <= @y + height
    end

    def click
      @click.call
    end

    def draw
      LibRay.draw_text_ex(
        sprite_font: LibRay.get_default_font,
        text: @text,
        position: LibRay::Vector2.new(x: @x + @width / 2 - @measure.x / 2, y: @y + @height / 2 - @measure.y / 2),
        font_size: FONT_SIZE,
        spacing: SPACING,
        color: @color
      )

      LibRay.draw_rectangle_lines(
        pos_x: @x,
        pos_y: @y,
        width: @width,
        height: @height,
        color: @color
      )
    end
  end
end
