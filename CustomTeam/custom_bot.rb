$LOAD_PATH << '../'
require 'MASWithTwoNests/Bot'

module CustomTeam
	class CustomBot < Bot
		def initialize
			super
		end

		def init_expert_system
			super
		end

		def update_facts
			super
		end

		def act
			super
		end

		def on_collide(agent)
			super
		end
	end
end

