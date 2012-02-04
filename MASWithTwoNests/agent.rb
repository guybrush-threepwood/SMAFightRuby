require 'rubygame'
$LOAD_PATH << '../'
require 'lib/point'
include Lib

module MASWithTwoNests
  class Agent
    attr_reader :target_point
    attr_reader :dead
    include Rubygame::Sprites::Sprite
    def initialize
      super
      @target_point = Point.new
      @direction = Point.new
      @dead = false
    end

    def current_point
      Point.new(rect.x, rect.y)
    end

    def change_direction
      @direction = Point.new(Random.rand, Random.rand)
      @direction.x = @direction.x * - 1 if Random.rand > 0.5
      @direction.y = @direction.y * - 1 if Random.rand > 0.5
      @direction.normalize!
    end
  end
end