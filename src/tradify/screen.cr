module Tradify
  class Screen
    BACKGROUND_COLOR = LibRay::Color.new(r: 30, g: 30, b: 30, a: 0)

    MARGIN  = 50
    BORDER  =  3
    PADDING = 25

    @chart : Chart

    def initialize(@game : Game, @x : Int32, @y : Int32, @width : Int32, @height : Int32, price_data : Array(Int32))
      @buttons = [] of Button

      action_width = 150
      @buttons << Button.new(
        game: @game,
        x: @width.to_f32 - MARGIN - BORDER - PADDING - action_width,
        y: MARGIN.to_f32 + BORDER + PADDING,
        text: "Buy",
        click: ->buy_click
      )
      @buttons << Button.new(
        game: @game,
        x: @width.to_f32 - MARGIN - BORDER - PADDING - action_width,
        y: MARGIN.to_f32 + BORDER + PADDING + @buttons[0].height + @buttons[0].padding,
        text: "Sell",
        click: ->sell_click
      )
      @buttons[1].disable

      @chart = Chart.new(
        x: MARGIN + BORDER + PADDING,
        y: MARGIN + BORDER + PADDING,
        width: @width - MARGIN * 2 - BORDER * 2 - PADDING * 2 - action_width,
        height: @height - MARGIN * 2 - BORDER * 2 - PADDING * 2,
        price_data: price_data
      )
    end

    def initialize(game)
      initialize(game: game, x: 0, y: 0, width: 0, height: 0, price_data: [] of Int32)
    end

    def buy_click
      @buttons[0].disable
      @buttons[1].enable

      price = @chart.price
      @chart.order_price_avg = price

      message = TypedMessage.new("Bought at: #{price}!")
      @game.show(message)

      true
    end

    def sell_click
      @buttons[0].enable
      @buttons[1].disable

      price = @chart.price
      @chart.order_price_avg = price

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
      @buttons.each(&.draw)
      # TODO: draw border
    end
  end
end
