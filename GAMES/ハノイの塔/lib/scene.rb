# sceneモジュールを微妙に改造
# 基本データの追記
require 'dxruby'

module Scene
  class Exit
  end

  class Base
    attr_accessor :next_scene
    attr_reader :frame_counter

    def initialize
      @next_scene = nil
      @frame_counter = 0
      init
    end

    def __update
      @frame_counter += 1
      update
    end
    private :__update

    def init
    end

    def quit
    end

    def update
    end

    def render
    end
  end

  def self.main_loop(scene_class, fps = 60, step = 1)
    scene = scene_class.new
    default_step = step

    Window.loop do
      exit if Input.keyPush?(K_ESCAPE)
      if Input.keyPush?(K_PGDN)
        step += 1
        Window.fps = fps * default_step / step
      end

      if Input.keyPush?(K_PGUP) and step > default_step
        step -= 1
        Window.fps = fps * default_step / step
      end

      step.times do
        break if scene.next_scene
        scene.__send__ :__update
      end

      scene.render

      if scene.next_scene
        scene.quit
        break if Exit == scene.next_scene
        scene = scene.next_scene.new
      end
    end
  end
end
#####################################################################
class Init_Scene  < Scene::Base
  def init_btn_make
    #@btn_full = Button.new(Window_w-72*2, 0, "full/win", 16,72,36)
    @btn_full = Button.new(Window_w-72*2, 0, "full", 16,72,36)
    @btn_esc = Button.new(Window_w-72, 0, "終了", 16,72,36)
  end
  
  def init_btn_update
    if @btn_full.pushed?
      if Window.windowed?
        @btn_full.string="win"
        Window.windowed = false
      else
        @btn_full.string="full"
        Window.windowed = true
      end
    elsif @btn_esc.pushed?
      exit
    end
  end

  def init_btn_render
    @btn_full.render
    @btn_esc.render
  end
  
  def logfile_open(string,templete)
    date = Time.now.strftime("%Y.%m.%d_%H.%M.%S")
    fname = "log/#{string}_#{date}.csv"
    $file = File::open(fname, "w")
    $file.puts "#{templete}"
  end
  
  def load_datafile_integer(filename)
    array = []
    open(filename) do |file|
      while l = file.gets
        #array.push l.chomp.split(//s)
        #array.push l.chomp.split(" ")
        array.push l.chomp.split(",")
      end
    end
    for i in 0 .. array.size-1
      for j in 0 .. array[i].size-1
        array[i][j] = array[i][j].to_i
      end
    end
    return array
  end

  def load_datafile(filename)
    array=Array.new()
    open(filename) do |file|
      while l = file.gets
        #array.push l.chomp.split(//s)
        array.push l.chomp.split(",")
      end
    end
    return array
  end
  
  def load_datafile_s(filename)
    array = []
    open(filename) do |file|
      while l = file.gets
         array.push l.chomp.split(//s)
         #array.push l.chomp.split(",")
      end
    end
    return array
  end
  
  def load_datafile_phonologic(filename)
    array = []
    open(filename) do |file|
      while l = file.gets
        array.push l.chomp.split(//)
      end
    end
    return array
  end
  
  def nm_array (n,m)
    (0..n).map {Array.new(m)}
  end
end
#################################################################
class S_Timer
  def self.reset  #時間を初期化
    @start_time = Time.now
  end

  def self.get  #経過時間を得る
    return Time.now - @start_time
  end 
end
##################################################################
if FileTest.exist?("log") == false
  Dir::mkdir("log")
end
##################################################################
