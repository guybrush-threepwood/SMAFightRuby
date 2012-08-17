module ExpertSystem
  class Fact
    attr_reader :label
		attr_reader :action
    def initialize(label, action = nil)
      @label = label
			@action = action
    end

    def ==(fact)
      fact.label == @label
    end

		def to_sym
			@label.to_sym
		end
  end
end
