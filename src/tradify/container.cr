module Tradify
  class Container
    getter x, y, width, height

    def initialize(@x : Int32, @y : Int32, @width : Int32, @height : Int32, @elements : Array(Container) = [] of Container)
    end

    def initialize
      initialize(x: 0, y: 0, width: 0, height: 0, elements: [] of Container)
    end

    def update
      @elements.each(&.update)
    end

    def draw
      @elements.each(&.draw)
    end
  end
end
