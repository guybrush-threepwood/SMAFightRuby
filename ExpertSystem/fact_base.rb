module ExpertSystem
  class FactBase
    attr_accessor :facts_values
    def initialize
      @facts_values = {}
    end

    def has_fact(fact)
      @facts_values[fact.to_sym]
    end
  end
end
