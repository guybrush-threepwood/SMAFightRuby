require 'rubygoo'
require 'rubygame'
include Rubygame
include Rubygoo
$LOAD_PATH << '../'
require "lib/point"
$LOAD_PATH << './'
require 'resource'
require 'bot_team'
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

    def initialize(screen)
			Rubygame::TTF.setup
			@screen = screen
      @home_getting_bigger = true
      @bot_start_from_home = false
      @background = Rubygame::Surface.new([WIDTH, HEIGHT])
      @agents = Rubygame::Sprites::Group.new
			Rubygame::Sprites::UpdateGroup.extend_object @agents
			RESOURCE_COUNT.times do
      	resource = Resource.new(self, RESOURCE_START_LIFE, RESOURCE_MOVE_DELAY * Random.rand, RESOURCE_MOVE_SPEED * Random.rand)
				resource.target_point = Point.new(Random.rand * WIDTH, Random.rand * HEIGHT)
				@agents << resource
				bot_team = BotTeam.new(self, "AntubisTeam", Rubygame::Color::ColorRGB.new([0.4,0.4,0.4]), ["truc"])
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

		def clean_dead_agents
			@agents.each do |a|
				@agents.kill(a) if a.dead
			end
		end

		def check_collisions
			#@agents.each do |i,j|
				#TODO: dispatch event if collided
			#end	
		end

    def is_out?(target_point)
			return true if (( target_point.x <= 0 || target_point.x >= WIDTH) || target_point.y <= 0 || target_point.y >= HEIGHT)
    end
  end
end
