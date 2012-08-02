require 'bot'

module MASWithTwoNests
	class AgentType

		attr_reader :ratio
		attr_reader :type
		def initialize(ratio = -1, _class = nil)
			@ratio = ratio
			@type = _class
		end

		AGENT_BOT = AgentType.new(1, Bot)
		AGENT_BOT_HOME = AgentType.new
		AGENT_RESOURCE = AgentType.new
	end
end
