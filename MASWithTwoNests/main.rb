require 'rubygoo'
require 'rubygame'
include Rubygame
include Rubygoo
$LOAD_PATH << './'
require 'resource'

module MASWithTwoNests
  class Main
    def initialize
      @screen = Screen.new [800, 600], 0, [HWSURFACE, DOUBLEBUF]
      @factory = AdapterFactory.new
      @world = World.new(@screen)
      @paused = false
      @render_adapter = @factory.renderer_for :rubygame, @screen
      @app = App.new :renderer => @render_adapter
      @clock = Clock.new
			@clock.enable_tick_events
      @clock.target_framerate = 30
      @clock.calibrate
      @pause_chkbx = CheckBox.new :x => 601, :y => 0, :w => 10, :h => 10, :label_text => "Pause"
      @home_chkbx = CheckBox.new :x => 601, :y => 20, :w => 10, :h => 10, :label_text => "Start from home"
      @exp_chkbx = CheckBox.new :x => 601, :y =>  40, :w => 10, :h => 10, :label_text => "Home expansion"
      @exp_chkbx.checked = true
      @restart_btn = Button.new "Restart", :x => 601, :y =>  80, :x_pad => 200, :y_pad => 10
      @app.add @pause_chkbx, @home_chkbx, @exp_chkbx, @restart_btn
      @restart_btn.on :pressed do
        @app_adapter.draw @render_adapter
        @world = World.new(@screen)
      end
      @pause_chkbx.on :checked do
        @app_adapter.draw @render_adapter
        @paused = !@paused
      end
      @home_chkbx.on :checked do
        @app_adapter.draw @render_adapter
        @world.bot_start_from_home = !@world.bot_start_from_home
      end
      @exp_chkbx.on :checked do
        @app_adapter.draw @render_adapter
        @world.home_getting_bigger = !@world.home_getting_bigger
      end
      @app_adapter = @factory.app_for :rubygame, @app
      @queue = EventQueue.new
      @app_adapter.draw @render_adapter
    end

    def run
      loop do
        update
				tick = @clock.tick
        @app_adapter.update tick
        @world.update(tick) if not @paused
        @screen.flip
      end
    end

    def update
      @queue.each do |event|
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
