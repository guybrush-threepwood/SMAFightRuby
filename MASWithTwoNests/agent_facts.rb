$LOAD_PATH << '../'
require 'ExpertSystem/fact'
include ExpertSystem

module MASWithTwoNests
  class AgentFacts
    NOTHING_SEEN          = Fact.new("Nothing seen")
    SEE_RESOURCE          = Fact.new("Resource seen")
    REACHED_RESOURCE      = Fact.new("Resource reached")
    GOT_RESOURCE          = Fact.new("Got resource")
    NO_RESOURCE           = Fact.new("Got no resource")
    BIGGER_RESOURCE       = Fact.new("Resource is bigger")
    SMALLER_RESOURCE      = Fact.new("Resource is smaller")
    CHANGE_DIRECTION_TIME = Fact.new("Time to change direction")
    SEEING_HOME           = Fact.new("Seeing home")
    NOT_SEEING_HOME       = Fact.new("Not seeing home")
    GO_HOME               = Fact.new("Go home")
    AT_HOME               = Fact.new("At home")
    CHANGE_DIRECTION      = Fact.new("Changing direction")
    GO_TO_RESOURCE        = Fact.new("Going to resource")
    TAKE_RESOURCE         = Fact.new("Taking Resource.")
    PUT_DOWN_RESOURCE     = Fact.new("Putting down Resource.")
  end
end