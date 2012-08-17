module ExpertSystem
  class FactBase
    def initialize
      @facts_values = {}
    end

    def has_fact(fact)
      @facts_values.keys.include?(fact.to_sym)
    end

    def add_fact(fact)
      @facts_values.store(fact.to_sym, false)
    end

    def set_fact_value(fact, value)
      @facts_values[fact.to_sym] = value
    end

    def get_fact_value(fact)
      @facts_values[fact.to_sym]
    end

    def reset_facts
      @facts_values.clear
    end
  end
end
