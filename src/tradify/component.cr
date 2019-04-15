module Tradify
  class Component
    property x : Int32
    property y : Int32
    property width : Int32
    property height : Int32
    property components : Array(Component)

    def initialize(@x = 0, @y = 0, @width = 0, @height = 0, @components = [] of Component)
    end

    def update
      update(0, 0)
    end

    def update(px, py)
      px += @x
      py += @y
      @components.each(&.update(px, py))
    end

    def draw
      draw(0, 0)
    end

    def draw(px, py)
      px += @x
      py += @y
      @components.each(&.draw(px, py))
    end
  end
end
