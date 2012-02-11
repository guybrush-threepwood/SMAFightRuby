require 'rubygoo'
require 'rubygame'
include Rubygame
include Rubygoo
$LOAD_PATH << '../'
require "lib/point"
$LOAD_PATH << './'
require 'resource'

module MASWithTwoNests
  class World
    attr_accessor :home_getting_bigger
    attr_accessor :bot_start_from_home

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
		RESOURCE_MOVE_DELAY = 7000
		RESOURCE_MOVE_SPEED = 110

		HOME_RADIUS = 10
		RESOURCE_RANDOM_START_LIFE = true

    def initialize
      @home_getting_bigger = true
      @bot_start_from_home = false
      @background = Rubygame::Surface.new([WIDTH, HEIGHT])
      @agents = Rubygame::Sprites::Group.new
      @agents << Resource.new(3)
    end

    def update(clock)
      @agents.update(clock)
    end

    def draw(screen)
      @background.blit(screen, [0, 0])
      @agents.draw(screen)
    end

    def is_out?

    end

  end
end
