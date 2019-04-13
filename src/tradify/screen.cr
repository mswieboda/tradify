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

      # chart
      @chart = Chart.new(
        x: MARGIN + BORDER + PADDING,
        y: MARGIN + BORDER + PADDING,
        width: width - MARGIN * 2 - BORDER * 2 - PADDING * 2 - action_container_width,
        height: height - MARGIN * 2 - BORDER * 2 - PADDING * 2,
        price_data: price_data
      )

      super(x, y, width, height)
    end

    def buy_click
      @buttons[0].disable
      @buttons[1].enable

      price = @chart.price
      @chart.order_price_avg = price
      @account.balance -= price

      message = TypedMessage.new("Bought at: #{price}!")
      @game.show(message)

      true
    end

    def sell_click
      @buttons[0].enable
      @buttons[1].disable

      price = @chart.price
      @chart.order_price_avg = price
      @account.balance += price

      message = TypedMessage.new("Sold at: #{price}!")
      @game.show(message)

      true
    end

    def update
      @chart.update
      @buttons.each(&.update)
    end

    def draw
      @chart.draw

      draw_account_info

      @buttons.each(&.draw)

      draw_border
    end

    def draw_account_info
      LibRay.draw_text_ex(
        sprite_font: @account_info_sprite_font,
        text: @account_info_text,
        position: @account_info_position,
        font_size: @account_info_font_size,
        spacing: @account_info_spacing,
        color: @account_info_color
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
