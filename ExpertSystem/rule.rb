module ExpertSystem
  class Rule
    attr_reader :goal
    attr_reader :premises
    def initialize(goal, premises)
      @goal = goal
      @premises = premises
    end

		def to_sym
			@goal.label.to_sym
		end
  end
end
