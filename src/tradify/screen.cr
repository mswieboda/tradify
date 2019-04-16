module Tradify
  class Screen < Component
    delegate price, to: @chart

    BACKGROUND_COLOR = LibRay::Color.new(r: 0, g: 0, b: 0, a: 0)
    BORDER_COLOR     = LibRay::Color.new(r: 0, g: 255, b: 0, a: 30)

    MARGIN  = 50
    BORDER  =  3
    PADDING = 25

    @game : Game
    @chart : Chart
    @side_panel_x : Int32
    @side_panel_y : Int32

    # @account_info_color : LibRay::Color
    @price_color : LibRay::Color

    def initialize(@game, @account : Account, price_data : Array(Int32), @level : Level, side_panel : Component = Component.new)
      x = 0
      y = 0
      width = Game::SCREEN_WIDTH
      height = Game::SCREEN_HEIGHT

      # chart
      @chart = Chart.new(
        x: MARGIN + BORDER + PADDING,
        y: MARGIN + BORDER + PADDING,
        width: width - MARGIN * 2 - BORDER * 2 - PADDING * 2 - side_panel.width,
        height: height - MARGIN * 2 - BORDER * 2 - PADDING * 2,
        price_data: price_data
      )

      # side_panel
      @side_panel_x = width - MARGIN - BORDER - side_panel.width
      @side_panel_y = MARGIN + BORDER + PADDING
      side_panel.height = height - MARGIN * 2 - BORDER * 2 - PADDING * 2 - side_panel.height

      # price
      @price_sprite_font = LibRay.get_default_font
      @price_font_size = 30
      @price_spacing = 3
      @price_text = "$0"
      @price_color = LibRay::WHITE
      @price_position = LibRay::Vector2.new(
        x: MARGIN + BORDER + PADDING * 2,
        y: MARGIN + BORDER + PADDING * 2
      )

      super(x, y, width, height, [side_panel])
    end

    def update_chart_lines
      if @account.open_trades?
        open_prices = @account.trades.select(&.open?).map(&.price)
        avg_price = open_prices.sum / open_prices.size
        @chart.order_price_avg = avg_price
      else
        @chart.order_price_avg = 0
      end
    end

    def update(px, py)
      super(px + @x + @side_panel_x, py + @y + @side_panel_y)

      @chart.update(px, py)

      update_chart_lines
    end

    def draw(px, py)
      super(@side_panel_x, @side_panel_y)
      return if hidden?

      @chart.draw

      draw_price

      draw_border
    end

    def draw_price
      LibRay.draw_text_ex(
        sprite_font: @price_sprite_font,
        text: "$#{@chart.price}",
        position: @price_position,
        font_size: @price_font_size,
        spacing: @price_spacing,
        color: @price_color
      )
    end

    def draw_border
      BORDER.times do |border|
        LibRay.draw_rectangle_lines(
          pos_x: @x + MARGIN + border,
          pos_y: @y + MARGIN + border,
          width: @width - @x - BORDER * 2 + PADDING * 2 - MARGIN * 3 - border * 2,
          height: @height - @y - BORDER * 2 + PADDING * 2 - MARGIN * 3 - border * 2,
          color: BORDER_COLOR
        )
      end
    end
  end
end
