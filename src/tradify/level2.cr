module Tradify
  class Level2 < Level
    INITIAL_BALANCE = 1000
    TARGET_PROFIT   =  100
    PRICE_DATA      = [300, 330, 350, 200, 220, 590, 680, 720, 200, 190, 200, 200, 200, 190, 130, 110, 110, 115, 115, 105, 100, 105, 100, 100, 135, 140, 140, 130, 120, 150, 155, 160, 180, 200, 220, 200]

    def load
      @account = Account.new(balance: INITIAL_BALANCE)
      @screen = Screen.new(
        game: @game,
        account: @account,
        price_data: PRICE_DATA,
        level: self
      )

      # if @level.number > 1
      #   @buttons << Button.new(
      #     game: @game,
      #     x: @buttons[0].x,
      #     y: @buttons[0].y + @buttons[0].height + PADDING,
      #     text: "Short",
      #     click: ->short_click
      #   )

      #   if @level.number < 3
      #     @buttons[1].disable
      #   end
      # end

      # # trades position
      # @account_info_trades_position = LibRay::Vector2.new(
      #   x: @account_info_position.x,
      #   y: @buttons[-1].y + @buttons[-1].height + PADDING
      # )
    end

    def start
      # ran once the level is loaded, and first update and draw ran
      @game.show(TypedMessage.new("Try to make money by buying and selling, with a different chart!")) unless Game::DEBUG
    end

    def target_reached?
      !@account.open_trades? && @account.balance > INITIAL_BALANCE + TARGET_PROFIT
    end

    def target_reached_message
      "Congrats, you made a profit of over $#{TARGET_PROFIT}!"
    end
  end
end
