require 'rubygems'
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
		def initialize(world, team_id, color, bot_types, bot_count)
			@world = world
			@team_id = team_id
			@color = color
			@bot_types = bot_types

			team_color = @color.to_rgba_ary
			2.times do |i|
				team_color[i] += 0.77333333
			end
			team_home = BotHome.new(@world, @team_id, Rubygame::Color::ColorRGB.new(team_color))
			@world.agents << team_home

      bot_types.each do |bot_type|
		    bot_type_count = bot_type.ratio * bot_count
				bot_class = bot_type.type

				bot_type_count.times do
          bot = bot_class.new(world, team_id, Rubygame::Color::ColorRGB.new(team_color), World::BOT_RADIUS, World::BOT_SPEED, World::BOT_DIRECTION_CHANGE_DELAY, World::BOT_PERCEPTION_RADIUS)

					if world.bot_start_from_home
				    bot.current_point = team_home.current_point
					else
						bot.current_point = Point.new(Random.rand * World::WIDTH, Random.rand * World::HEIGHT)
					end
					@world.agents << bot
				end
			end
		end
	end
end
