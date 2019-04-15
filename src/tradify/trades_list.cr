module Tradify
  class TradesList < Component
    def initialize(@account : Account, x = 0, y = 0, width = 0, height = 0, components = [] of Component)
      super(x, y, width, height, components)
    end

    def update(px, py)
      super(px, py)
    end

    def draw(px, py)
      super(px, py)

      draw_trades(px, py)
    end

    def draw_trades(px, py)
      @account.trades.reverse.each_with_index do |trade, trade_index|
        text = trade.to_s

        measure = LibRay.measure_text_ex(
          sprite_font: LibRay.get_default_font,
          text: text,
          font_size: Label::FONT_SIZE,
          spacing: Label::SPACING
        )

        y = py + @y + (measure.y + Label::SPACING) * trade_index

        break if y > py + @y + height

        if trade.open?
          color = LibRay::WHITE
        else
          color = LibRay::GRAY
        end

        LibRay.draw_text_ex(
          sprite_font: LibRay.get_default_font,
          text: text,
          position: LibRay::Vector2.new(
            x: px + @x + width - measure.x - Screen::BORDER * 2 - Screen::PADDING,
            y: y,
          ),
          font_size: Label::FONT_SIZE,
          spacing: Label::SPACING,
          color: color
        )
      end
    end
  end
end
