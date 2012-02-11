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
		def initialize(world, team_id, color)
			super(world)
			@team_id = team_id
			@color = color
			@count_text = ""
			@image = Rubygame::Surface.new([World::HOME_RADIUS * 2, World::HOME_RADIUS * 2])
			@rect = @image.make_rect
			@image.draw_circle_s(@rect.center, Rubygame::Color::ColorRGB.new([0.1, 0.1, 0.1, 1]))
		end

		def add_resource
			@resource_count += 1
		end
	end
end
 
