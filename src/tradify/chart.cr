module Tradify
  class Chart
    property order_price_avg : Int32

    BACKGROUND_COLOR = LibRay::Color.new(r: 30, g: 30, b: 30, a: 0)
    GRID_COLOR       = LibRay::Color.new(r: 0, g: 255, b: 0, a: 30)
    PLOT_COLOR       = LibRay::GREEN

    GRID_SIZE      = 50
    GRID_THICKNESS =  1

    LINE_THICKNESS       =   4
    LINE_THICKNESS_RATIO = 2.0
    POINT_SIZE           = LINE_THICKNESS * 1.5

    DATA_INTERVAL = 0.25

    def initialize(@x : Int32, @y : Int32, @width : Int32, @height : Int32, @price_data : Array(Int32), @order_price_avg : Int32 = 0)
      @timer = Timer.new(DATA_INTERVAL)
      @price_index = 0
      @prices = [] of Int32
      @view_x = @view_y = 0
    end

    def initialize
      initialize(x: 0, y: 0, width: 0, height: 0)
    end

    def price
      index = @price_index - 1
      index = 0 if index < 0
      @price_data[index % @price_data.size]
    end

    def next_price
      @price_data[@price_index % @price_data.size]
    end

    def update
      delta_t = LibRay.get_frame_time

      @timer.increase(delta_t)

      @view_x = @price_index * GRID_SIZE / 2 - @width
      @view_x = 0 if @view_x < 0
      @view_y = 0

      if @timer.done? && @price_data.any?
        @prices << next_price
        @price_index += 1
        @timer.restart
      end
    end

    def draw
      draw_background
      draw_grid
      draw_plot
      draw_order_price_avg_line
    end

    def draw_background
      LibRay.draw_rectangle_v(
        position: LibRay::Vector2.new(x: @x, y: @y),
        size: LibRay::Vector2.new(x: @width, y: @height),
        color: BACKGROUND_COLOR
      )
    end

    def draw_grid
      # vertical
      ((@width / GRID_SIZE).round + 1).times do |grid_x|
        LibRay.draw_rectangle_v(
          position: LibRay::Vector2.new(
            x: @x + grid_x * GRID_SIZE,
            y: @y
          ),
          size: LibRay::Vector2.new(
            x: GRID_THICKNESS,
            y: @height
          ),
          color: GRID_COLOR
        )
      end

      # horizontal
      ((@height / GRID_SIZE).round + 1).times do |grid_y|
        LibRay.draw_rectangle_v(
          position: LibRay::Vector2.new(
            x: @x,
            y: @y + grid_y * GRID_SIZE
          ),
          size: LibRay::Vector2.new(
            x: @width,
            y: GRID_THICKNESS
          ),
          color: GRID_COLOR
        )
      end
    end

    def draw_plot
      last_px = 0
      last_py = 0

      @prices.each_with_index do |price, price_x|
        px = @x + price_x * GRID_SIZE / 2
        py = @y + @height / 2 - price

        unless px < @x + @view_x || px > @x + @view_x + @width
          # points
          if Game::DEBUG
            LibRay.draw_rectangle_v(
              position: LibRay::Vector2.new(x: px - @view_x - POINT_SIZE / 2, y: py - POINT_SIZE / 2),
              size: LibRay::Vector2.new(x: POINT_SIZE, y: POINT_SIZE),
              color: PLOT_COLOR
            )
          end

          # lines
          if price_x > 0
            LINE_THICKNESS.times do |thickness|
              LibRay.draw_line_v(
                start_pos: LibRay::Vector2.new(x: last_px - @view_x, y: last_py + thickness / LINE_THICKNESS_RATIO),
                end_pos: LibRay::Vector2.new(x: px - @view_x, y: py + thickness / LINE_THICKNESS_RATIO),
                color: PLOT_COLOR
              )
              LibRay.draw_line_v(
                start_pos: LibRay::Vector2.new(x: last_px - @view_x, y: last_py - thickness / LINE_THICKNESS_RATIO),
                end_pos: LibRay::Vector2.new(x: px - @view_x, y: py - thickness / LINE_THICKNESS_RATIO),
                color: PLOT_COLOR
              )
            end
          end
        end

        last_px = px
        last_py = py
      end
    end

    def draw_order_price_avg_line
      if @order_price_avg > 0
        y = @y + @height / 2 - @order_price_avg

        LINE_THICKNESS.times do |thickness|
          LibRay.draw_line_v(
            start_pos: LibRay::Vector2.new(x: @x, y: y + thickness / LINE_THICKNESS_RATIO),
            end_pos: LibRay::Vector2.new(x: @x + @width, y: y + thickness / LINE_THICKNESS_RATIO),
            color: PLOT_COLOR
          )
          LibRay.draw_line_v(
            start_pos: LibRay::Vector2.new(x: @x, y: y - thickness / LINE_THICKNESS_RATIO),
            end_pos: LibRay::Vector2.new(x: @x + @width, y: y - thickness / LINE_THICKNESS_RATIO),
            color: PLOT_COLOR
          )
        end
      end
    end
  end
end
