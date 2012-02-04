require 'rubygoo'
require 'rubygame'
include Rubygame
include Rubygoo
$LOAD_PATH << './'
require 'resource'

module MASWithTwoNests
  class Main
    attr_reader :clock
    def initialize
      @screen = Screen.new [800, 600]
      @factory = AdapterFactory.new
      @render_adapter = @factory.renderer_for :rubygame, @screen
      @app = App.new :renderer => @render_adapter
      @clock = Clock.new
      @clock.target_framerate = 20
      @clock.calibrate
      @pause_chkbx = CheckBox.new :x => 601, :y => 0, :w => 10, :h => 10, :label_text => "Pause"
      @home_chkbx = CheckBox.new :x => 601, :y => 20, :w => 10, :h => 10, :label_text => "Start from home"
      @exp_chkbx = CheckBox.new :x => 601, :y =>  40, :w => 10, :h => 10, :label_text => "Home expansion"
      @exp_chkbx.checked = true
      @restart_btn = Button.new "Restart", :x => 601, :y =>  80, :x_pad => 200, :y_pad => 10
      @app.add @pause_chkbx, @home_chkbx, @exp_chkbx, @restart_btn
      @restart_btn.on :pressed do
        @world = World.new(@screen)
      end
      @app_adapter = @factory.app_for :rubygame, @app
      @queue = EventQueue.new
      @world = World.new(@screen)
    end

    def run
      loop do
        update
        @app_adapter.update @clock.tick
        @app_adapter.draw @render_adapter
        @world.update
        @world.draw
      end
    end

    def update
      @queue.each do |event|
        # pass on our events to the GUI
        if event.class == QuitEvent
          throw :rubygame_quit
        end
        @app_adapter.on_event event
      end
    end

    m = Main.new
    m.run
  end
end