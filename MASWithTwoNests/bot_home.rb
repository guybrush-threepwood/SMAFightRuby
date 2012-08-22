require 'rubygems'
$LOAD_PATH << '../'
require 'lib/point'
include Lib
$LOAD_PATH << './'
require 'agent'
require 'world'
require 'rubygame'

module MASWithTwoNests
  class BotHome < Agent
		attr_reader :team_id
		attr_reader :resource_count
		def initialize(world, team_id, color)
			super(world)
			@resource_count = 0
			@team_id = team_id
			@color = color
			@radius = nil
			@center = [rand * World::HEIGHT, rand * World::HEIGHT]
			draw_sprite(world)
		end

		def update(tick, world)
			draw_sprite(world)
		end

		def add_resource
			@resource_count += 1
		end

		private

		def draw_sprite(world)
			new_radius = nil
			if world.home_getting_bigger
				new_radius = World::HOME_RADIUS + @resource_count
			else
				new_radius = World::HOME_RADIUS
			end
			if new_radius != @radius or @radius == nil
				@radius = new_radius
				@image = Rubygame::Surface.new([@radius * 2, @radius * 2])
				@rect = @image.make_rect
				@image.set_colorkey([0, 0, 0])
				@image.draw_circle_s(@rect.center, @radius, @color)
				@rect.center = @center
			end
		end
	end
end
