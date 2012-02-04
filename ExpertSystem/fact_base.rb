module ExpertSystem
  class FactBase
    attr_accessor :facts_values
    def initialize
      @facts_values = {}
    end

    def has_fact(fact)
      @facts_values.each do |f|
        return true if f == fact
      end
      return false
    end
  end
end