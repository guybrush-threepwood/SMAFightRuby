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
require 'resource'

module MASWithTwoNests
	class Bot < Agent
		attr_reader :home_position
		attr_reader :team_id
		attr_accessor :has_resource
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
			@current_color = nil

      init_expert_system
			init_sprite
			draw_sprite
			change_direction
		end

		def init_sprite
			@image = Rubygame::Surface.new([@radius, @radius])
      @image.set_colorkey([0, 0, 0])
			@rect = @image.make_rect
		end

		def draw_sprite
			if @has_resource
				if @current_color != @resource_color
			    @image.draw_circle_s(@rect.center, @radius, @resource_color)
					@current_color = @resource_color
				end
			else
				if @current_color != @color
			    @image.draw_circle_s(@rect.center, @radius, @color)
					@curent_color = @color
				end
			end
		end

		def update(tick, world)
			update_facts(tick)
			infer
			act
			draw_sprite
			move(tick)

			@reached_resource = nil
			@home = nil
		end

		def init_expert_system
			@expert_system = ExpertSystem::ExpertSystem.new

      @expert_system.add_rule(Rule.new(AgentFacts::GO_TO_RESOURCE,[ AgentFacts::NO_RESOURCE,
			                                                             	AgentFacts::SEE_RESOURCE,
			                                                             	AgentFacts::CHANGE_DIRECTION_TIME]))

			@expert_system.add_rule(Rule.new(AgentFacts::TAKE_RESOURCE,[ 	AgentFacts::NO_RESOURCE,
																																		AgentFacts::REACHED_RESOURCE]))

			@expert_system.add_rule(Rule.new(AgentFacts::GO_HOME, [	AgentFacts::GOT_RESOURCE,
																															AgentFacts::SEEING_HOME]))

			@expert_system.add_rule(Rule.new(AgentFacts::GO_TO_RESOURCE,[	AgentFacts::GOT_RESOURCE,
																																		AgentFacts::SEE_RESOURCE,
																																		AgentFacts::BIGGER_RESOURCE,
																																		AgentFacts::NOT_SEEING_HOME,
																																		AgentFacts::CHANGE_DIRECTION_TIME]))

			@expert_system.add_rule(Rule.new(AgentFacts::CHANGE_DIRECTION,[ AgentFacts::GOT_RESOURCE,
																																			AgentFacts::SEE_RESOURCE,
																																			AgentFacts::SMALLER_RESOURCE,
																																			AgentFacts::CHANGE_DIRECTION_TIME]))

			@expert_system.add_rule(Rule.new(AgentFacts::PUT_DOWN_RESOURCE,[	AgentFacts::GOT_RESOURCE,
																																				AgentFacts::REACHED_RESOURCE]))

			@expert_system.add_rule(Rule.new(AgentFacts::PUT_DOWN_RESOURCE,[ 	AgentFacts::AT_HOME,
																																				AgentFacts::GOT_RESOURCE ]))

			@expert_system.add_rule(Rule.new(AgentFacts::CHANGE_DIRECTION,[ AgentFacts::NOTHING_SEEN,
																																			AgentFacts::CHANGE_DIRECTION_TIME ]))

			@expert_system.add_rule(Rule.new(AgentFacts::CHANGE_DIRECTION, [AgentFacts::TAKE_RESOURCE]))

			@expert_system.add_rule(Rule.new(AgentFacts::CHANGE_DIRECTION, [AgentFacts::PUT_DOWN_RESOURCE]))
		end

		def infer
			@expert_system.infer
		end

		def update_facts(tick)
			if @has_resource
				@expert_system.set_fact_value(AgentFacts::GOT_RESOURCE, true)
			else
				@expert_system.set_fact_value(AgentFacts::NO_RESOURCE, true)
			end

			@update_time += tick.milliseconds
			if @update_time > @direction_change_delay
				@expert_system.set_fact_value(AgentFacts::CHANGE_DIRECTION_TIME, true)
				@update_time = 0
			end

			if @seen_resource
				@expert_system.set_fact_value(AgentFacts::SEE_RESOURCE, true)
				if @taken_resource
					if @seen_resource.life > @taken_resource.life
						@expert_system.set_fact_value(AgentFacts::BIGGER_RESOURCE, true)
					else
						@expert_system.set_fact_value(AgentFacts::SMALLER_RESOURCE, true)
					end
				end
			else
				@expert_system.set_fact_value(AgentFacts::NOTHING_SEEN, true)
			end

			if @home
				if is_collided?(@home)
					@expert_system.set_fact_value(AgentFacts::AT_HOME, true)
				else
					@expert_system.set_fact_value(AgentFacts::NOT_SEEING_HOME, true)
				end
			else
				@expert_system.set_fact_value(AgentFacts::NOT_SEEING_HOME, true)
			end
		end

		def go_to_resource
			if @seen_resource
				@direction = @seen_resource.current_point - @target_point
				@direction.normalize!
				@seen_resource = nil
			end
		end

		def take_resource
			if @reached_resource
				@reached_resource.decrease_life
				@has_resource = true
				@taken_resource = @reached_resource
				@last_reached_resource = @reached_resource
				@reached_resource = nil
			end
			@seen_resource = nil
		end

		def go_home
			if (@home_position)
				@direction = @home_position - @target_point
				@direction.normalize!
			end
		end

		def put_down_resource
			if @home
				@home.add_resource
				@home = nil
			else
				if @reached_resource
					@reached_resource.increase_life
					@last_reached_resource = @reached_resource
					@reached_resource = nil
					@taken_resource = nil
				end
			end
			@has_resource = false
			@taken_resource = nil
		end

		def act
			@expert_system.inferred_facts.each do |fact|
				send(fact.action)
			end
		end

		def move(tick)
			real_speed = @speed
			if(@has_resource)
				real_speed *= World::BOT_WITH_RESOURCE_SPEED_COEFF
			end

			@target_point.x = current_point.x + @direction.x * real_speed * tick.seconds
			@target_point.y = current_point.y + @direction.y * real_speed * tick.seconds
			super()
		end

		def steal_resource(bot)
			bot.has_resource = false
			@has_resource = true
		end

		def drop_resource
			drop(Resource.new(@world, World::RESOURCE_UPDATE_VALUE, World::RESOURCE_MOVE_DELAY, World::RESOURCE_MOVE_SPEED)) if @has_resource
		end

		def drop(agent)
			agent.target_point = Point.new(@target_point.x, @target_point.y)
			@world.add_agent(agent)
		end

		def is_collided?(agent)
			collide_sprite?(agent)
		end

		def is_perceived?(agent)
			return (Point.distance(agent.current_point, current_point) <= @perception_radius)
		end

		def on_collision(agent)
			if agent.class == Resource
				@reached_resource = agent
			end
			return agent
		end

		def on_perception(agent)
			if agent.class == Resource
				if agent != @last_reached_resource or @last_reached_resource == nil
					@seen_resource = agent
				end
			end

      if agent.class == BotHome and agent.team_id == @team_id
				@home = agent
				if @home_position == nil
					@home_position = agent.current_point
				end
			end
			return agent
		end

		def infer
      @expert_system.infer
		end
	end
end
