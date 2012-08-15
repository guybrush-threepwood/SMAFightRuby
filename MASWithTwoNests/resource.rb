require 'rubygems'
$LOAD_PATH << '../'
require 'lib/point'
include Lib
$LOAD_PATH << './'
require 'agent'
require 'world'
require 'rubygame'

module MASWithTwoNests
  class Resource < Agent
    attr_reader :life
    def initialize(world, life, move_delay = 0, speed = 0)
      super(world)
      @move_delay = move_delay
      @update_time = 0
      @speed = speed
      if World::RESOURCE_RANDOM_START_LIFE
        @life = life * rand + World::RESOURCE_UPDATE_VALUE
      else
        @life = life
      end
      @image = Rubygame::Surface.new([World::RESOURCE_LIFE_RADIUS_COEFF * @life * 2, World::RESOURCE_LIFE_RADIUS_COEFF * @life * 2])
      @rect = @image.make_rect
      @image.set_colorkey([0, 0, 0])
			@image.draw_circle_s(@rect.center, (World::RESOURCE_LIFE_RADIUS_COEFF * @life), Rubygame::Color::ColorRGB.new([0.8, 0.8 , 0.8, 1])) if @life > 0
			@rect.center = [rand * World::HEIGHT, rand * World::HEIGHT]
			change_direction
    end

    def decrease_life
      @life = @life - World::RESOURCE_UPDATE_VALUE
    end

    def increase_life
      @life = @life + World::RESOURCE_UPDATE_VALUE
    end

    def update(tick, world)
			@dead = true if @life <= 0

			@update_time += tick.milliseconds
			if @update_time > @move_delay or world.is_out?(@target_point)
				change_direction
				@update_time = 0
			end
			
			@target_point.x += @direction.x * @speed * tick.seconds
			@target_point.y += @direction.y * @speed * tick.seconds

			move
		end
  end
end
