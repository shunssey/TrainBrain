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
  def item_init
####################################################################
    @key_window  = Images.new(20*30+60+$masu_posi[0], $masu_posi[1], 100, 100, "", 24, Gray, Black)
    @key_window.image("./image/item_window2.png")
    @weapon_window  = Images.new(@height*30+200+$masu_posi[0], $masu_posi[1], 100, 100, "", 24, Gray, Black)
    @weapon_window.image("./image/item_window2.png")
    @item_window = Images.new(@height*30+50+$masu_posi[0], $masu_posi[1]+150, 250, 450, "", 24, Gray, Black)
    @item_window.image("./image/frame4.png")
    @key = Array.new
##########################鍵を配置するやつ（アイテムをどう配置するか）
#=begin
    @item = Array.new
    @item_x = Array.new
    @item_y = Array.new
    $key_number =  4 #可変にする
    $road[$road_count]
    $key_color = Array.new
    $key_color = ["key_red","key_blue","key_yellow","key_pink","key_green"]
    @takarabako_color = [Red,Blue,Yellow,Pink,Green]
    for i in 0..$key_number
      @r = rand($road_count)+1
      @item[i] = Images.new($road[@r][1]*30+$masu_posi[0], $road[@r][0]*30+$masu_posi[1], 30, 30, "", 24, Gray, Black)
      @item_x[i] = @item[i].x
      @item_y[i] = @item[i].y
      @item[i].image("./image/key30/#{$key_color[i]}.png")
    end
##########################敵の情報を教えるもの（アイテムをどう配置するか）
    $map = Array.new
##########################武器を配置するやつ（アイテムをどう配置するか）
    @weapon = Array.new
    @weapon_x = Array.new
    @weapon_y = Array.new
    $weapon_number = 2 #$weapon_numberと敵の種類を同じにする 
    for i in 0..$weapon_number
      @weapon_r = rand($road_count)+1
      @weapon[i] = Images.new($road[@weapon_r][1]*30+$masu_posi[0], $road[@weapon_r][0]*30+$masu_posi[1], 30, 30, "", 24, Gray, Black)
      @weapon[i].image("./image/weapon_30/item_#{i}.png")
      @weapon_x[i] = @weapon[i].x
      @weapon_y[i] = @weapon[i].y
    end
  end #init
  
  def item_update
  
  end #update
  
  def item_render
    for i in 0..$key_number
      @item[i].render
    end
    
    for i in 0..$weapon_number
      @weapon[i].render
    end
    @key_window.render
    @weapon_window.render
    @item_window.render
  end #render
end #scene
##################################################################
