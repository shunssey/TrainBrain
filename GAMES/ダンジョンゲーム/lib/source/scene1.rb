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
    @BG_img = Images.new(0,0,1,1)
    @BG_img.image("./image/BG_title.png")
    @title        = Fonts.new(0, Window_h/3, "#{Title}", 72, Black)
    @title.x      = (Window_w - @title.get_width)/2
    @btn_start    = Button.new(0, 0, 170, 90, "はじめる", 36)
    @btn_start.image("./image/btn_image/btn_image_blue.png")
    @btn_start.waku(Red,10)
    @btn_setting    = Button.new(0, 0, 170, 90, "設定", 36)
    #@btn_setting.image("./image/btn_image/btn_image_blue.png")
    @btn_item    = Button.new(0, 0, 170, 90, "アイテム", 36)
    @btn_item.image("./image/btn_image/btn_image_blue.png")
    @btn_full     = Button.new(0, 0, 72,  36, "full/win", 16)
    @btn_esc      = Button.new(0, 0, 72,  36, "終了",     16)
    @btn_start.set_pos((Window_w - @btn_start.w)/2, (Window_h - @btn_start.h)/2)
    #@btn_setting.set_pos((Window_w - @btn_start.w)/2, (Window_h - @btn_start.h)/2 + 100)
    @btn_setting.set_pos(0,0)
    #@btn_item.set_pos((Window_w - @btn_start.w)/2, (Window_h - @btn_start.h)/2 + 200)
    @btn_item.set_pos((Window_w - @btn_start.w)/2, (Window_h - @btn_start.h)/2 + 130)
    @btn_full.set_pos(Window_w - @btn_full.w*2, 0)
    @btn_esc.set_pos(Window_w - @btn_esc.w, 0)
    @select_state = "start"
  end #init
  
  def title_update
    if @btn_full.pushed?
      if Window.windowed?
        Window.windowed = false
      else
        Window.windowed = true
      end
    end
    exit if @btn_esc.pushed?
    #self.next_scene = Main_Scene if @btn_start.pushed?
    if @btn_start.pushed?
      $bgm_title.stop
      @btn_item.image("./image/btn_image/btn_image_blue.png")
      @btn_start.waku(Red,10)
      self.next_scene = Stageselect_Scene
    end
    
    if @btn_item.pushed?
      $bgm_title.stop
      @btn_start.image("./image/btn_image/btn_image_blue.png")
      @btn_item.waku(Red,10)
      self.next_scene = Item_Scene
    end
    
    if @btn_setting.pushed?
      $bgm_title.stop
      self.next_scene = Setting_Scene
    end
    
    
    if @btn_full.pushed?
      if Window.windowed?
        Window.windowed = false
      else
        Window.windowed = true
      end
    end
    
    #コントローラ操作
    if Input.keyPush?(K_UP)
      $select_SE.play
      @btn_item.image("./image/btn_image/btn_image_blue.png")
      @btn_start.waku(Red,10)
      @select_state = "start"
    end
    
    if Input.keyPush?(K_DOWN)
      $select_SE.play
      @btn_start.image("./image/btn_image/btn_image_blue.png")
      @btn_item.waku(Red,10)
      @select_state = "item"
    end
    
#=begin
    if Input.keyPush?(K_SPACE)
      if @select_state == "start"
        $bgm_title.stop
        $ok_SE.play
        self.next_scene = Stageselect_Scene
      elsif @select_state == "item"
        $bgm_title.stop
        $ok_SE.play
        self.next_scene = Item_Scene
      end
    end
#=end
  end #update
  
  def title_render
    @BG_img.render
    @btn_start.render
    @btn_setting.render
    @btn_item.render
    @btn_full.render
    @btn_esc.render
    @title.render
  end #render
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
