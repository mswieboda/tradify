module Tradify
  class Level1 < Level
    INITIAL_BALANCE = 1000
    TARGET_PROFIT   =  100
    PRICE_DATA      = [50, 70, 90, 40, 60, 30, 80, 100, 130, 150, 130, 110, 100, 90, 110, 130, 120, 110, 90, 70, 50, 60, 50, 40, 50, 70, 60]

    def load
      @account = Account.new(balance: INITIAL_BALANCE)
      @screen = Screen.new(
        game: @game,
        account: @account,
        price_data: PRICE_DATA
      )
    end

    def target_reached?
      @account.balance >= INITIAL_BALANCE + TARGET_PROFIT
    end

    def target_reached_message
      "Congrats, you made a profit of $#{TARGET_PROFIT}!"
    end
  end
end
