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
		attr_reader 	:agents

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
			Rubygame::Sprites::UpdateGroup.extend_object @agents
			@immortal_agents = []

			RESOURCE_COUNT.times do
				resource = Resource.new(self, RESOURCE_START_LIFE, RESOURCE_MOVE_DELAY * rand, RESOURCE_MOVE_SPEED * rand)
				resource.target_point = Point.new(rand * WIDTH, rand * HEIGHT)
				add_agent(resource)
			end

			@bot_teams = []
			bot_team = BotTeam.new(self, "DefaultTeam", Rubygame::Color::ColorRGB.new([0.4, 0.4, 0.4]), [AgentType::AGENT_BOT], BOT_COUNT / 2)
			@bot_teams << bot_team
    end

		def add_agent(agent)
			ancestors = agent.class.ancestors
			if ancestors.include?(Agent)
				@agents << agent
				if ancestors.include?(Bot) or ancestors.include?(BotHome)
					@immortal_agents << agent
				end
			end
		end

    def update(tick)
			@background.blit @screen, [0, 0]
			@agents.undraw @screen, @background
      @agents.update(tick, self)
			@agents.draw @screen
			clean_dead_agents
			check_collisions
    end

    def is_out?(target_point)
			return true if (( target_point.x <= 0 || target_point.x >= WIDTH) || target_point.y <= 0 || target_point.y >= HEIGHT)
    end

		private

		def clean_dead_agents
			@agents - @immortal_agents.each do |r|
				@agents.delete(r) if r.dead
			end
		end

		def check_collisions
			notified_bots = []
			@bot_teams.each do |bot_team|
				others = (@agents - bot_team.bots) - notified_bots
				if others.any?
					bot_team.bots.each do |bot|
						others.each do |agent|
							notify_bot(bot, agent, notified_bots)
						end
					end
				else
					break
				end
			end	
		end

		def notify_bot(bot, agent, notified_bots, bot_check = true)
			notified = nil
			if bot.is_collided?(agent)
				notified = bot.on_collision(agent)
			end
			if bot.is_perceived?(agent)
				notified = bot.on_perception(agent)
			end
			notified_bots << bot if notified
			if bot_check and agent.class.ancestors.include?(Bot)
				notify_bot(agent, bot, false)
			end
		end
  end
end
