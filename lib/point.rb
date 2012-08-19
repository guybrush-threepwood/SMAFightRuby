module Lib
  class Point
    attr_accessor :x
    attr_accessor :y
    def initialize(x = 0, y = 0)
      @x = x
      @y = y
    end

    def self.distance(point, other_point)
      a = (point.x - other_point.x).abs
      b = (point.y - other_point.y).abs
      Math.sqrt(a * a + b * b).floor
    end

    def length
      Point.distance(self, Point.new(0, 0))
    end

		def ==(other)
			return false if other == nil
			@x.to_i == other.x.to_i and @y.to_i == other.y.to_i
	  end

		def -(other)
			@x -= other.x
			@y -= other.y
			return self
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
