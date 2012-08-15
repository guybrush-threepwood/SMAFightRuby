require 'rubygems'
gem 'test-unit'
require 'test/unit'
require 'rubygoo'
require "../MASWithTwoNests/main"
include MASWithTwoNests

class TestMain < Test::Unit::TestCase
  def setup
    @main = Main.new
  end

  def test_get_start_home_checkbox
    assert_equal Rubygoo::CheckBox, @main.instance_variable_get(:@home_chkbx).class
  end

  def test_has_app
    assert_equal Rubygoo::App, @main.instance_variable_get(:@app).class
  end
end
