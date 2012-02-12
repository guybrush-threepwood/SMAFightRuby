$LOAD_PATH << '../'
require 'lib/point'
include Lib
$LOAD_PATH << './'
require 'agent'
require 'world'
require 'rubygame'
require 'bot_home'

module MASWithTwoNests
	class BotTeam < Agent
		attr_reader :team_id
		def initialize(world, team_id, color, bot_types)
			@world = world
			@team_id = team_id
			@color = color
			@bot_types = bot_types

			team_color = @color.to_rgba_ary
			2.times do |i|
				team_color[i] += 0.13333333
			end
			team_home = BotHome.new(@world, @team_id, Rubygame::Color::ColorRGB.new(team_color))
			@world.agents << team_home
		end
	end
end
