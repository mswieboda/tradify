module Tradify
  class Game
    getter? game_over
    getter? paused

    @levels : Array(Level)
    @level : Level | Nil
    @message : Message

    @game_over_text_color : LibRay::Color

    SCREEN_WIDTH  = 1280
    SCREEN_HEIGHT =  768

    DEBUG = false

    TARGET_FPS = 60
    DRAW_FPS   = DEBUG

    GAME_OVER_TIME = 1.5

    def initialize
      LibRay.init_window(SCREEN_WIDTH, SCREEN_HEIGHT, "Tradify")
      LibRay.set_target_fps(TARGET_FPS)

      # game over
      @game_over = false
      @game_over_timer = Timer.new(GAME_OVER_TIME)
      @game_over_text_font = LibRay.get_default_font
      @game_over_text = "GAME OVER"
      @game_over_text_font_size = 100
      @game_over_text_spacing = 15
      @game_over_text_color = LibRay::WHITE
      @game_over_text_measured = LibRay.measure_text_ex(
        sprite_font: @game_over_text_font,
        text: @game_over_text,
        font_size: @game_over_text_font_size,
        spacing: @game_over_text_spacing
      )
      @game_over_text_position = LibRay::Vector2.new(
        x: SCREEN_WIDTH / 2 - @game_over_text_measured.x / 2,
        y: SCREEN_HEIGHT / 2 - @game_over_text_measured.y,
      )

      @message = Message.new

      # levels
      @levels = [] of Level
      @level_index = 0

      [Level1, Level2, Level3, Level4].each do |level_class|
        @levels << level_class.new(self).as(Level)
      end

      level = @levels[@level_index]
      level.load
      @level = level
    end

    def level
      @level.as(Level)
    end

    def pause
      @paused = true
    end

    def unpause
      @paused = false
    end

    def check_game_over?
      !paused? && @level_index >= @levels.size
    end

    def change_level
      @level_index += 1

      return if @level_index >= @levels.size

      new_level = @levels[@level_index]
      new_level.load

      @level = new_level
    end

    def show(message : Message)
      pause
      message.open

      @message = message
    end

    def run
      while !LibRay.window_should_close?
        update
        draw_init
      end

      close
    end

    def update
      level.update unless paused?

      @message.update

      unpause if @message.just_closed?

      change_level if level.completed? || LibRay.key_pressed?(LibRay::KEY_ONE)

      if check_game_over?
        @game_over_timer.increase(LibRay.get_frame_time)

        if @game_over_timer.done?
          @game_over_timer.reset
          @game_over = true
          pause
        end
      end
    end

    def draw
      level.draw

      @message.draw

      if game_over?
        LibRay.draw_text_ex(
          sprite_font: @game_over_text_font,
          text: @game_over_text,
          position: @game_over_text_position,
          font_size: @game_over_text_font_size,
          spacing: @game_over_text_spacing,
          color: @game_over_text_color
        )
      end

      LibRay.draw_fps(0, 0) if DRAW_FPS
    end

    def draw_init
      LibRay.begin_drawing
      LibRay.clear_background LibRay::BLACK

      draw

      LibRay.end_drawing
    end

    def close
      LibRay.close_window
    end
  end
end
