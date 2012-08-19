require 'rubygems'
require 'rubygame'
$LOAD_PATH << '../'
require 'lib/point'
include Lib

module MASWithTwoNests
  class Agent
    attr_accessor :target_point
    attr_reader :dead
    include Rubygame::Sprites::Sprite
    def initialize(world)
      super()
			@world = world
      @target_point = Point.new
      @direction = Point.new
      @dead = false
    end
		
    def current_point
      Point.new(rect.center[0], rect.center[1])
    end

		def current_point=(point)
			@rect.center = [point.x, point.y]
		end

    def change_direction
      @direction = Point.new(rand, rand)
      @direction.x = @direction.x.to_i - 1 if rand > 0.5
      @direction.y = @direction.y.to_i - 1 if rand > 0.5
      @direction.normalize!
    end
  end
end
