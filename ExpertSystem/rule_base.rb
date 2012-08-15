module ExpertSystem
  class RuleBase
    attr_reader :rules
    def initialize
      @rules = []
    end

    def add_rule(rule)
      @rules << rule
    end
  end
end
