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
		
		def move
			@rect.center = [@target_point.x, @target_point.y] unless @world.is_out?(@target_point)
		end

    def current_point
      Point.new(rect.center[0], rect.center[1])
    end

    def change_direction
      @direction = Point.new(Random.rand, Random.rand)
      @direction.x = @direction.x * - 1 if Random.rand > 0.5
      @direction.y = @direction.y * - 1 if Random.rand > 0.5
      @direction.normalize!
    end
  end
end
