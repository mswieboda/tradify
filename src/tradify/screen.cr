module Tradify
  class Screen < Component
    BACKGROUND_COLOR = LibRay::Color.new(r: 0, g: 0, b: 0, a: 0)
    BORDER_COLOR     = LibRay::Color.new(r: 0, g: 255, b: 0, a: 30)

    MARGIN  = 50
    BORDER  =  3
    PADDING = 25

    @game : Game
    @chart : Chart
    @account_info_color : LibRay::Color
    @price_color : LibRay::Color

    def initialize(@game, @account : Account, price_data : Array(Int32))
      x = 0
      y = 0
      width = Game::SCREEN_WIDTH
      height = Game::SCREEN_HEIGHT

      # container
      action_container_width = 150

      # account info
      @account_info_sprite_font = LibRay.get_default_font
      @account_info_font_size = 20
      @account_info_spacing = 3
      @account_info_text = "$#{@account.balance}"
      @account_info_color = LibRay::WHITE
      @account_info_measure = LibRay.measure_text_ex(
        sprite_font: LibRay.get_default_font,
        text: @account_info_text,
        font_size: @account_info_font_size,
        spacing: @account_info_spacing
      )
      @account_info_position = LibRay::Vector2.new(
        x: width - MARGIN - BORDER - action_container_width,
        y: MARGIN + BORDER + PADDING
      )

      # buttons
      @buttons = [] of Button
      @buttons << Button.new(
        game: @game,
        x: @account_info_position.x.to_i,
        y: @account_info_position.y.to_i + @account_info_measure.y.to_i + PADDING,
        text: "Buy",
        click: ->buy_click
      )

      @buttons << Button.new(
        game: @game,
        x: @buttons[0].x,
        y: @buttons[0].y + @buttons[0].height + PADDING,
        text: "Sell",
        click: ->sell_click
      )
      @buttons[1].disable

      # trades position
      @account_info_trades_position = LibRay::Vector2.new(
        x: @account_info_position.x,
        y: @buttons[-1].y + @buttons[-1].height + PADDING
      )

      # chart
      @chart = Chart.new(
        x: MARGIN + BORDER + PADDING,
        y: MARGIN + BORDER + PADDING,
        width: width - MARGIN * 2 - BORDER * 2 - PADDING * 2 - action_container_width,
        height: height - MARGIN * 2 - BORDER * 2 - PADDING * 2,
        price_data: price_data
      )

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

      super(x, y, width, height)
    end

    def buy_click
      @buttons[0].disable
      @buttons[1].enable

      price = @chart.price

      @account.execute_trade(Trade.new(price: price, action: Action::Buy))

      trade_executed(price)

      true
    end

    def trade_executed(price)
      update_account_info

      if @account.open_trades?
        @chart.order_price_avg = price
      else
        @chart.order_price_avg = 0
      end
    end

    def sell_click
      @buttons[0].enable
      @buttons[1].disable

      price = @chart.price

      @account.execute_trade(Trade.new(price: price, action: Action::Sell))

      trade_executed(price)

      true
    end

    def update
      update_account_info

      @chart.update
      @buttons.each(&.update)
    end

    def update_account_info
      @account_info_text = "$#{@account.balance}"
    end

    def draw
      draw_account_info

      @chart.draw

      draw_price

      @buttons.each(&.draw)

      draw_border
    end

    def draw_account_info
      # balance
      LibRay.draw_text_ex(
        sprite_font: @account_info_sprite_font,
        text: @account_info_text,
        position: @account_info_position,
        font_size: @account_info_font_size,
        spacing: @account_info_spacing,
        color: @account_info_color
      )

      # trades
      @account.trades.reverse.each_with_index do |trade, trade_index|
        y = @account_info_trades_position.y + @account_info_measure.y + PADDING * trade_index

        break if y > @height - MARGIN * 2 - BORDER * 2

        text = "1 @ $#{trade.price}"
        text = "-" + text if trade.sell?

        measure = LibRay.measure_text_ex(
          sprite_font: LibRay.get_default_font,
          text: text,
          font_size: @account_info_font_size,
          spacing: @account_info_spacing
        )

        if trade.open?
          color = LibRay::WHITE
        else
          color = LibRay::GRAY
        end

        LibRay.draw_text_ex(
          sprite_font: @account_info_sprite_font,
          text: text,
          position: LibRay::Vector2.new(
            x: width - MARGIN - BORDER - PADDING - measure.x,
            y: @account_info_trades_position.y + @account_info_measure.y + PADDING * trade_index,
          ),
          font_size: @account_info_font_size,
          spacing: @account_info_spacing,
          color: color
        )
      end
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
