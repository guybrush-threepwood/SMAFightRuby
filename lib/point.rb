module Lib
  class Point
    attr_accessor :x
    attr_accessor :y
    def initialize(x = 0, y = 0)
      @x = x
      @y = y
    end

    def Point.distance(point, other_point)
      a = (point.x - other_point.x).abs
      b = (point.y - other_point.y).abs
      Math.sqrt(a * a + b * b).floor
    end

    def length
      Point.distance(self, Point.new(0, 0))
    end

    def normalize!(length_scale = 1)
      @x = length_scale if @x > length_scale
      @y = length_scale if @y > length_scale
      while length < length_scale
        @x = @x + 1
        @y = @y + 1
      end
    end
  end
end