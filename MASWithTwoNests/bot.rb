$LOAD_PATH << '../'
require 'lib/point'
include Lib
require 'ExpertSystem/expert_system.rb'
include ExpertSystem
$LOAD_PATH << './'
require 'agent'
require 'resource'
require 'world'
require 'rubygame'
require 'bot_home'

module MASWithTwoNests
	class Bot < Agent
		attr_reader :home_position
		attr_reader :team_id
		def initialize(world, team_id, color, radius, speed, direction_change_delay, perception_radius)
			super(world)
			@team_id = team_id
			@speed = speed
			@image = Rubygame::Surface.new([ perception_radius, perception_radius ])
      @image.set_colorkey([0, 0, 0])
			@rect = @image.make_rect
			@direction_change_delay = direction_change_delay
			@image.draw_circle_s(@rect.center, radius * 2, color)
			@target_point = Point.new(Random.rand * World::WIDTH, Random.rand * World::HEIGHT)

			@direction = nil
			@radius = radius
			@perception_radius = perception_radius
			@color = color

			@expert_system = nil

			@has_resource = false
			@seen_resource = nil
			@taken_resource = nil
			@reached_resource = nil
			@last_reached_resource = nil
			@update_time = 0

			@home = nil
			@home_position = nil

      init_expert_system
			change_direction
		end

		def update(tick, world)
			move
		end

		def init_expert_system
			expert_system = ExpertSystem::ExpertSystem.new()


		end

		def update_facts
		end

		def act
		end

		def on_collide(agent)
			if collide_sprite? agent
				if agent.class == Resource
					@reached_resource = agent
				end
			end
		end
	end
end
