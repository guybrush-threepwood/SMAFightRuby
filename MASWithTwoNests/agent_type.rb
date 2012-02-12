module MASWithTwoNests
	class AgentType
		attr_reader :ratio
		attr_reader :type
		def initialize(ratio, _class)
			@ratio = ratio
			@type = _class
		end
	end
end
