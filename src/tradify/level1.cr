module Tradify
  class Level1 < Level
    INITIAL_BALANCE = 1000
    TARGET_PROFIT   =  100
    PRICE_DATA      = [70, 50, 70, 90, 40, 20, 15, 30, 10, 20, 30, 40, 45, 30, 50, 70, 60, 80, 100, 130, 150, 190, 140, 130, 110, 100, 90, 110, 130, 120, 150, 140, 160, 100, 90, 110, 90, 70, 50, 60, 50, 40, 50, 70, 60]

    def load(balance = INITIAL_BALANCE)
      @account = Account.new(balance: balance)

      side_panel_components = [] of Component

      # balance
      @balance_label = Label.new(0, 0, text: "$#{@account.balance}")
      side_panel_components << @balance_label.as(Component)

      load_buttons(side_panel_components)

      # side panel
      side_panel = Component.new(
        width: [150, side_panel_components.map(&.width).max + Screen::PADDING].max,
        components: side_panel_components
      )

      # screen
      @screen = Screen.new(
        game: @game,
        account: @account,
        price_data: PRICE_DATA,
        level: self,
        side_panel: side_panel
      )

      # trades position
      side_panel_components << TradesList.new(
        account: @account,
        x: side_panel_components.last.x,
        y: side_panel_components.last.y + side_panel_components.last.height + Screen::PADDING,
        width: side_panel.width,
        height: side_panel.height - side_panel_components.map(&.width).sum - Screen::PADDING
      )
    end

    def load_buttons(side_panel_components)
      # buy
      @buy_button = Button.new(
        game: @game,
        x: side_panel_components.last.x,
        y: side_panel_components.last.y + side_panel_components.last.height + Screen::PADDING,
        text: "Buy",
        click: buy_click_proc
      )
      side_panel_components << @buy_button.as(Component)

      # sell
      @sell_button = Button.new(
        game: @game,
        x: side_panel_components.last.x,
        y: side_panel_components.last.y + side_panel_components.last.height + Screen::PADDING,
        text: "Sell",
        click: sell_click_proc
      )
      sell_button.disable
      side_panel_components << @sell_button.as(Component)
    end

    def start
      # ran once the level is loaded, and first update and draw ran
      @game.show(TypedMessage.new(["Welcome to Tradify.", "Try to make money by buying and selling!"])) unless Game::DEBUG
    end

    def balance_label
      @balance_label.as(Label)
    end

    def buy_button
      @buy_button.as(Button)
    end

    def buy_click_proc
      ->buy_click
    end

    def sell_button
      @sell_button.as(Button)
    end

    def sell_click_proc
      ->sell_click
    end

    def trades_position
      @trades_position.as(LibRay::Vector2)
    end

    def update
      super

      balance_label.text = "$#{@account.balance}"
    end

    def buy(price)
      @account.execute_trade(Trade.new(action: Action::Buy, price: price))
    end

    def sell(price)
      @account.execute_trade(Trade.new(action: Action::Sell, price: price))
    end

    def buy_click
      buy(screen.price)

      buy_button.disable
      sell_button.enable

      true
    end

    def sell_click
      sell(screen.price)

      buy_button.enable
      sell_button.disable

      true
    end

    def target_reached?
      !@account.open_trades? && @account.balance > INITIAL_BALANCE + TARGET_PROFIT
    end

    def target_reached_message
      "Congrats, you made a profit of over $#{TARGET_PROFIT}!"
    end
  end
end
