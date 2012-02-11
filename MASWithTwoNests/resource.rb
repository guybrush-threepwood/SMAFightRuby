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
    def initialize(life, move_delay = 0, speed = 0)
      super()
      @move_delay = move_delay
      @update_time = 0
      @speed = speed
      if World::RESOURCE_RANDOM_START_LIFE
        @life = life * Random.rand + World::RESOURCE_UPDATE_VALUE
      else
        @life = life
      end
      @image = Rubygame::Surface.new([World::RESOURCE_LIFE_RADIUS_COEFF * @life * 2, World::RESOURCE_LIFE_RADIUS_COEFF * @life * 2])
      @rect = @image.make_rect
      @image.set_colorkey([0, 0, 0])
      change_direction
    end

    def decrease_life
      @life = @life - World::RESOURCE_UPDATE_VALUE
    end

    def increase_life
      @life = @life + World::RESOURCE_UPDATE_VALUE
    end

    def draw(arg)
      @image.draw_circle_s(@rect.topleft, World::RESOURCE_LIFE_RADIUS_COEFF * @life, Rubygame::Color::ColorRGB.new([0, 0 , 1, 1]))
      super(arg)
    end

    def update(clock)


    end
  end
end