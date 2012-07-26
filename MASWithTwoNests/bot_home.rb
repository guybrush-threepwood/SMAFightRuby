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
			@image = Rubygame::Surface.new([World::HOME_RADIUS * 2, World::HOME_RADIUS * 2])
			@rect = @image.make_rect
      @image.set_colorkey([0, 0, 0])
			@image.draw_circle_s(@rect.center, World::HOME_RADIUS, Rubygame::Color::ColorRGB.new([0.22745, 0.22745, 0.22745, 1]))
			@rect.center = [Random.rand * World::HEIGHT, Random.rand * World::HEIGHT]
		end

		def update(tick, world)
		end

		def add_resource
			@resource_count += 1
		end
	end
end
