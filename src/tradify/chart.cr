module Tradify
  class Chart
    BACKGROUND_COLOR = LibRay::Color.new(r: 30, g: 30, b: 30, a: 0)
    GRID_COLOR       = LibRay::Color.new(r: 0, g: 255, b: 0, a: 30)
    PLOT_COLOR       = LibRay::GREEN

    GRID_SIZE      = 50
    GRID_THICKNESS =  1

    POINT_SIZE           =   4
    LINE_THICKNESS       =   4
    LINE_THICKNESS_RATIO = 2.0

    POINTS = [50, 70, 90, 40, 60, 30, 80, 100, 130, 150, 130, 110, 100, 90, 110, 130, 120, 110, 90, 70, 50, 60, 50, 40, 50, 70, 60]

    DATA_INTERVAL = 0.5

    def initialize(@x : Int32, @y : Int32, @width : Int32, @height : Int32)
      @timer = Timer.new(DATA_INTERVAL)
      @point_index = 0
      @points = [] of Int32
    end

    def initialize
      initialize(x: 0, y: 0, width: 0, height: 0)
    end

    def update
      delta_t = LibRay.get_frame_time

      @timer.increase(delta_t)

      if @timer.done?
        @points << POINTS[@point_index]
        @point_index += 1
        @point_index = 0 if @point_index >= POINTS.size
        @timer.restart
      end
    end

    def draw
      draw_background
      draw_grid
      draw_plot
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
      last_px = @x - POINT_SIZE / 2
      last_py = @y + @height / 2 - POINT_SIZE / 2

      @points.each_with_index do |point, point_x|
        px = @x + point_x * GRID_SIZE / 2 - POINT_SIZE / 2
        py = @y + @height / 2 + point - POINT_SIZE / 2

        # point
        LibRay.draw_rectangle_v(
          position: LibRay::Vector2.new(x: px, y: py),
          size: LibRay::Vector2.new(x: POINT_SIZE, y: POINT_SIZE),
          color: PLOT_COLOR
        )

        # line
        LibRay.draw_line_v(
          start_pos: LibRay::Vector2.new(x: last_px, y: last_py),
          end_pos: LibRay::Vector2.new(x: px, y: py),
          color: PLOT_COLOR
        )

        # thickness
        LINE_THICKNESS.times do |thickness|
          # puts "t: #{thickness}"
          LibRay.draw_line_v(
            start_pos: LibRay::Vector2.new(x: last_px, y: last_py + thickness / LINE_THICKNESS_RATIO),
            end_pos: LibRay::Vector2.new(x: px, y: py + thickness / LINE_THICKNESS_RATIO),
            color: PLOT_COLOR
          )
          LibRay.draw_line_v(
            start_pos: LibRay::Vector2.new(x: last_px, y: last_py - thickness / LINE_THICKNESS_RATIO),
            end_pos: LibRay::Vector2.new(x: px, y: py - thickness / LINE_THICKNESS_RATIO),
            color: PLOT_COLOR
          )
        end

        last_px = px
        last_py = py
      end
    end
  end
end
