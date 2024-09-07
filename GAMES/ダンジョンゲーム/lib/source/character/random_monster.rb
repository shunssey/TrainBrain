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
  
  #タイトル画面の諸々の定義↓ここから↓
  def random_monster_init
    $random_monster_move_count = Array.new
    for i in $trace_monster_number..$random_monster_number
      $random_monster_move_count[i] = 0 #キャラクターの移動のカウント
    end
    $random_monster_move_count2 = 30 #キャラクターがこのカウントより大きくなった時に動き出す。
    $monster_direct = 0
  end #init
  
  def random_monster_update
#追いかける
    for i in $trace_monster_number..$random_monster_number #for
      $random_monster_move_count[i] += 1
      if $random_monster_move_count[i] > $random_monster_move_count2
        if $player.x != $monster2[i+1].x #横の座標に差があるとき
          if $player.x <= $monster2[i+1].x && $maze["#{$monster2[i+1].y/30}".to_i]["#{$monster2[i+1].x/30}".to_i-1] != 1 #左に進む
            $monster2[i+1] = Array_Images.new($monster2[i+1].x, $monster2[i+1].y,"./image/character/monster2.png",3,4,3)
            $monster2[i+1].x -= 30
            $random_monster_move_count[i] = 0 
          elsif $player.x >= $monster2[i+1].x && $maze["#{$monster2[i+1].y/30}".to_i]["#{$monster2[i+1].x/30}".to_i+1] != 1 #右に進む
            $monster2[i+1] = Array_Images.new($monster2[i+1].x, $monster2[i+1].y,"./image/character/monster2.png",3,4,6)
            $monster2[i+1].x += 30
            $random_monster_move_count[i] = 0
          end
        end
        
        if $player.y != $monster2[i+1].y #縦の座標に差があるとき
          if $player.y <= $monster2[i+1].y && $maze["#{$monster2[i+1].y/30}".to_i-1]["#{$monster2[i+1].x/30}".to_i] != 1 #上に進む
            $monster2[i+1] = Array_Images.new($monster2[i+1].x, $monster2[i+1].y,"./image/character/monster2.png",3,4,9)
            $monster2[i+1].y -= 30
            $random_monster_move_count[i] = 0
          elsif $player.y >= $monster2[i+1].y && $maze["#{$monster2[i+1].y/30}".to_i+1]["#{$monster2[i+1].x/30}".to_i] != 1 #下に進む
            $monster2[i+1] = Array_Images.new($monster2[i+1].x, $monster2[i+1].y,"./image/character/monster2.png",3,4,0)
            $monster2[i+1].y += 30
            $random_monster_move_count[i] = 0
          end
        end
      end
    end #for
  end #update
  
  def random_monster_render
    
  end #render

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
