module ExpertSystem
  class Rule
    attr_reader :goal
    attr_reader :premises
    def initialize(goal, premises)
      @goal = goal
      @premises = premises
    end
  end
end