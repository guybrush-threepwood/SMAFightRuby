module ExpertSystem
  class Fact
    attr_reader :label
    def initialize(label)
      @label = label
    end

    def ==(fact)
      fact.label == @label
    end

		def to_sym
			@label.to_sym
		end
  end
end
