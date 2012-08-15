require 'rubygems'
require 'rubygoo'
require 'rubygame'
include Rubygame
include Rubygoo
$LOAD_PATH << '../'
require "lib/point"
$LOAD_PATH << './'
require 'resource'
require 'bot_team'
require 'agent_type'
include Lib

module MASWithTwoNests
  class World
    attr_accessor :home_getting_bigger
    attr_accessor :bot_start_from_home
		attr_accessor :agents
		attr_accessor :screen

    WIDTH = 600
    HEIGHT = 600

		BOT_WITH_RESOURCE_SPEED_COEFF = 1
		BOT_RADIUS = 2
		BOT_PERCEPTION_RADIUS = 40
		BOT_COUNT = 80
		BOT_INIT_POSITION = Point.new(WIDTH / 2, HEIGHT / 2)
		BOT_SPEED = 100
		BOT_DIRECTION_CHANGE_DELAY = 500

		RESOURCE_LIFE_RADIUS_COEFF = 10
		RESOURCE_START_LIFE = 3
		RESOURCE_UPDATE_VALUE = 0.1
		RESOURCE_RESPAWN_DELAY = 500
		RESOURCE_COUNT = 15
		RESOURCE_MOVE_DELAY = 500
		RESOURCE_MOVE_SPEED = 110

		HOME_RADIUS = 10
		RESOURCE_RANDOM_START_LIFE = true

    def initialize(screen, bot_start_from_home = false, home_getting_bigger = true)
			Rubygame::TTF.setup
			@screen = screen
      @home_getting_bigger = home_getting_bigger
      @bot_start_from_home = bot_start_from_home
      @background = Rubygame::Surface.new([WIDTH, HEIGHT])
      @agents = Rubygame::Sprites::Group.new
			@bot_teams = []
			Rubygame::Sprites::UpdateGroup.extend_object @agents
			RESOURCE_COUNT.times do
      	resource = Resource.new(self, RESOURCE_START_LIFE, RESOURCE_MOVE_DELAY * Random.rand, RESOURCE_MOVE_SPEED * Random.rand)
				resource.target_point = Point.new(Random.rand * WIDTH, Random.rand * HEIGHT)
				@agents << resource
			end
			bot_team = BotTeam.new(self, "DefaultTeam", Rubygame::Color::ColorRGB.new([0.4, 0.4, 0.4]), [AgentType::AGENT_BOT], BOT_COUNT/2)
			@bot_teams << bot_team
    end

    def update(tick)
			@background.blit @screen, [0, 0]
			@agents.undraw @screen, @background
      @agents.update(tick, self)
			@agents.draw @screen
			clean_dead_agents
			check_collisions
    end

		def clean_dead_agents
			@agents.each do |a|
				@agents.delete(a) if a.dead
			end
		end

		def check_collisions
			@bot_teams.each do |bot_team|
				others = @agents - bot_team.bots
				bot_team.bots.each do |bot|
					others.each do |agent|
					  if bot.collide(agent)
						  bot.on_collide(agent) if (bot.is_collided?(agent) or bot.is_perceived?(agent))
						end
					end
				end
			end	
		end

    def is_out?(target_point)
			return true if (( target_point.x <= 0 || target_point.x >= WIDTH) || target_point.y <= 0 || target_point.y >= HEIGHT)
    end
  end
end
