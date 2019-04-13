module Tradify
  class Screen < Component
    BACKGROUND_COLOR = LibRay::Color.new(r: 30, g: 30, b: 30, a: 0)

    MARGIN  = 50
    BORDER  =  3
    PADDING = 25

    @game : Game
    @chart : Chart

    def initialize(@game, @account : Account, price_data : Array(Int32))
      x = 0
      y = 0
      width = Game::SCREEN_WIDTH
      height = Game::SCREEN_HEIGHT

      @buttons = [] of Button

      action_width = 150
      @buttons << Button.new(
        game: @game,
        x: width - MARGIN - BORDER - PADDING - action_width,
        y: MARGIN + BORDER + PADDING,
        text: "Buy",
        click: ->buy_click
      )
      @buttons << Button.new(
        game: @game,
        x: width - MARGIN - BORDER - PADDING - action_width,
        y: MARGIN + BORDER + PADDING + @buttons[0].height + @buttons[0].padding,
        text: "Sell",
        click: ->sell_click
      )
      @buttons[1].disable

      @chart = Chart.new(
        x: MARGIN + BORDER + PADDING,
        y: MARGIN + BORDER + PADDING,
        width: width - MARGIN * 2 - BORDER * 2 - PADDING * 2 - action_width,
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
