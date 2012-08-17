$LOAD_PATH << '../ExpertSystem/'
require 'fact_base'
require 'rule_base'
require 'rule'
require 'fact'

module ExpertSystem
  class ExpertSystem
    attr_reader :fact_base
    attr_reader :inferred_facts
    def initialize
      @fact_base = FactBase.new
      @rule_base = RuleBase.new
      @inferred_facts = []
    end

    def add_rule(rule)
      @fact_base.add_fact(rule) if not @fact_base.has_fact(rule)

      rule.premises.each do |p|
        @fact_base.add_fact(p) if not @fact_base.has_fact(p)
      end

      @rule_base.add_rule(rule)
    end

    def infer
      clear_inferred_facts

      begin
        valid_rule = get_valid_rule
				if valid_rule
					@fact_base.set_fact_value(valid_rule.goal, true)
					@inferred_facts << valid_rule.goal
				end
      end while valid_rule != nil
    end

		def set_fact_value(fact, value)
			@fact_base.set_fact_value(fact, value)
		end

		private

    def is_rule_valid(rule)
      return false if @fact_base.get_fact_value(rule.goal)

      rule.premises.each do |p|
        return @fact_base.get_fact_value(p)
      end
    end

    def get_valid_rule
      @rule_base.rules.each do |r|
				return r if is_rule_valid(r)
			end
			return nil
    end

    def clear_inferred_facts
      @inferred_facts = []
    end
  end
end
