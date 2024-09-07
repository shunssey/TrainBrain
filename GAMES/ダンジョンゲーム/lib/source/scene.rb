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
  
  #タイトル画面の諸々の定義　↓ここから↓
  def title_init
    @title        = Fonts.new(0, Window_h/3, "#{Title}", 72, Black)
    @title.x      = (Window_w - @title.get_width)/2
    @btn_start    = Button.new(0, 0, 150, 70, "はじめる", 36)
    @btn_setting    = Button.new(0, 0, 150, 70, "設定", 36)
    @btn_full     = Button.new(0, 0, 72,  36, "full/win", 16)
    @btn_esc      = Button.new(0, 0, 72,  36, "終了",     16)
    @btn_start.set_pos((Window_w - @btn_start.w)/2, (Window_h - @btn_start.h)/2)
    @btn_setting.set_pos((Window_w - @btn_start.w)/2, (Window_h - @btn_start.h)/2 + 100)
    @btn_full.set_pos(Window_w - @btn_full.w*2, 0)
    @btn_esc.set_pos(Window_w - @btn_esc.w, 0)
  end
  
  def title_update
    if @btn_full.pushed?
      if Window.windowed?
        Window.windowed = false
      else
        Window.windowed = true
      end
    end
    exit if @btn_esc.pushed?
    
    self.next_scene = Main_Scene if @btn_start.pushed?
  end
  
  def title_render
    @btn_start.render
    @btn_setting.render
    @btn_full.render
    @btn_esc.render
    @title.render
  end
  #タイトル画面の諸々の定義　↑ここまで↑

  #ファイルを,区切りで読み込んで配列として格納
  def load_datafile(filename)
    array = []
    open(filename) do |file|
      while l = file.gets
         array.push l.chomp.split(",")
         #array.push l.chomp.split(//s)
      end
    end
    return array
  end
  
  #n×mの多次元配列を生成し、vで要素を埋める
  def nm_array(n=1, m=1, v=nil)  
    (1..n).map {Array.new(m){v}}
  end
  
  ##########################################　プログレスバー　###################################################
  
  def init_progress_bar(parameter)
    @bar_gray = Images.new(Window_w/2-253,20, Dgray, 506, 30)
    @bar_gray.x, @bar_gray.y = Window_w/2-@bar_gray.w/2*$ratio_x, Window_h/38.4.to_f
    @bar_green = Images.new(Window_w/2-250,23, Green, 500, 24)
    @bar_green.x, @bar_green.y = Window_w/2-@bar_green.w/2*$ratio_x, Window_h/33.4.to_f
    @exit_condition = parameter
    @percentage = 0
    @flag_end = :off
  end
  
  def progress_bar_update(exit_condition)
    if @flag_end == :off
      @percentage = (100-exit_condition/@exit_condition*100).to_i
      if @percentage > 0 
        @bar_green.width(500*@percentage/100.to_i)
      elsif @percentage == 0 
        @bar_green = nil
        @flag_end = :on
      end
    end
  end
  
  def progress_bar_render
    @bar_gray.render
    if @bar_green != nil
      @bar_green.render
    end
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

class Clear_Timer
  def self.reset  #時間を初期化
    @start_time = Time.now
  end

  def self.get  #経過時間を得る
    return Time.now - @start_time
  end 
end

class Anime_Timer
  def self.reset  #時間を初期化
    @start_time = Time.now
  end

  def self.get  #経過時間を得る
    return Time.now - @start_time
  end 
end
##################################################################
