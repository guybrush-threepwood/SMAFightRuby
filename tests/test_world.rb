require 'rubygems'
gem 'test-unit'
require 'test/unit'
require 'rubygoo'
require "../MASWithTwoNests/world"
include MASWithTwoNests

class TestMain < Test::Unit::TestCase
  def setup
    @world = World.new
  end

  def test_has_width
    assert_equal MASWithTwoNests::World, @world.class
  end
end

