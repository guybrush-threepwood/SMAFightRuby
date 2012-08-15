require 'rubygems'
$LOAD_PATH << '../'
require 'lib/point'
include Lib
require 'ExpertSystem/expert_system'
require 'ExpertSystem/rule'
include ExpertSystem
$LOAD_PATH << './'
require 'agent'
require 'agent_facts'
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
			@direction_change_delay = direction_change_delay

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

			resource_color_ary = @color.to_rgba_ary
			3.times do |i|
				resource_color_ary[i] += 0x55 #0X228822
			end
			@resource_color = Rubygame::Color::ColorRGB.new([resource_color_ary[0], resource_color_ary[1], resource_color_ary[2]])

      init_expert_system
			init_sprite
			draw_sprite
			change_direction
		end

		def init_sprite
			@image = Rubygame::Surface.new([ @radius, @radius ])
      @image.set_colorkey([0, 0, 0])
			@rect = @image.make_rect
		end

		def draw_sprite
			if (@has_resource)
			  @image.draw_circle_s(@rect.center, @radius, @resource_color)
			else
			  @image.draw_circle_s(@rect.center, @radius, @color)
			end
		end

		def update(tick, world)
			draw_sprite
			update_facts
			infer
			act
			move

			@reached_resource = nil
			@home = nil
		end

		def init_expert_system
			@expert_system = ExpertSystem::ExpertSystem.new()

      @expert_system.add_rule(Rule.new(AgentFacts::GO_TO_RESOURCE,[ AgentFacts::NO_RESOURCE,
			                                                             	AgentFacts::SEE_RESOURCE,
			                                                             	AgentFacts::CHANGE_DIRECTION_TIME]))
		end

		def infer
			@expert_system.infer
		end

		def update_facts
		end

		def act
		end

		def is_collided?(agent)
			collide_sprite?(agent)
		end

		def is_perceived?(agent)
			return (Point.distance(agent.current_point, current_point) <= @perception_radius)
		end

		def on_collide(agent)
      if is_collided? agent
				if agent.class == Resource
					@reached_resource = agent
				end
			else
				if agent.class == Resource
					#The last reached resource can't be seen
					if agent != @last_reached_resource or @last_reached_resource == nil
						@seen_resource = agent
					end
				end
			end

      if agent.class == BotHome and agent.team_id == @team_id
				@home = agent
				if @home_position == nil
					@home_position = agent.current_point
				end
			end
		end

		def infer
      @expert_system.infer
		end
	end
end
