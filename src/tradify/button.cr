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
    HOVERED_COLOR  = LibRay::GREEN

    def initialize(@game : Game, x, y, @text : String, @click : Proc(Bool) = ->{ false }, @padding = PADDING)
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
      @hovered = false
    end

    def disable
      @disabled = true
    end

    def enable
      @disabled = false
    end

    def enabled?
      !disabled?
    end

    def hovered?
      @hovered
    end

    def color
      if disabled?
        DISABLED_COLOR
      else
        if hovered?
          HOVERED_COLOR
        else
          DEFAULT_COLOR
        end
      end
    end

    def remeasure
      @measure = LibRay.measure_text_ex(
        sprite_font: LibRay.get_default_font,
        text: @text,
        font_size: FONT_SIZE,
        spacing: SPACING
      )
      @width = @measure.x.round.to_i + @padding * 2
      @height = @measure.y.round.to_i + @padding * 2
    end

    def update(px, py)
      return if disabled?

      mouse = LibRay.get_mouse_position

      if over?(px, py, mouse)
        @hovered = true

        click if LibRay.mouse_button_pressed?(LibRay::MOUSE_LEFT_BUTTON)
      else
        @hovered = false
      end
    end

    def over?(px, py, mouse)
      mouse.x >= px + @x && mouse.x <= px + @x + width &&
        mouse.y >= py + @y && mouse.y <= py + @y + height
    end

    def click
      @click.call
    end

    def draw(px, py)
      super
      return if hidden?

      LibRay.draw_text_ex(
        sprite_font: LibRay.get_default_font,
        text: @text,
        position: LibRay::Vector2.new(x: px + @x + @width / 2 - @measure.x / 2,
          y: py + @y + @height / 2 - @measure.y / 2
        ),
        font_size: FONT_SIZE,
        spacing: SPACING,
        color: color
      )

      LibRay.draw_rectangle_lines(
        pos_x: px + @x,
        pos_y: py + @y,
        width: @width,
        height: @height,
        color: color
      )
    end
  end
end
