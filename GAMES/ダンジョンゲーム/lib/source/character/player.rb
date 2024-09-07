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
$monster_SE  = Sound.new("./lib/sound/hitting1.wav")
$player_SE  = Sound.new("./lib/sound/kick1.wav")
#####################################################################
class Init_Scene  < Scene::Base
  
  #タイトル画面の諸々の定義　↓ここから↓
  def player_init
    $player = Array_Images.new(50, 50,"./image/character/player.png",3,4,0)
    $player_up_count = 0
    $player_down_count = 0
    $player_right_count = 0
    $player_left_count = 0
    $player_move_count = 0 #プレイヤーの動きの速度制限
    $move_count = 0
  end #init
  
  def player_update
    #常にプレイヤーのいた場所が１になる
    #p $maze["#{($player.y-$masu_posi[1])/30}".to_i]["#{($player.x-$masu_posi[0])/30}".to_i] = 1 
    #上に進む
if $player_move_stop == "OFF" #処理をやるときに落ちないようにするもの
    if Input.keyPush?(K_UP) && $maze["#{($player.y-$masu_posi[1])/30}".to_i-1]["#{($player.x-$masu_posi[0])/30}".to_i] != 1 #マップの先が岩じゃない時
      @player_direct = "UP"
      if $player.y == 30
        $player = Array_Images.new($player.x, $player.y,"./image/character/player.png",3,4,9)
      elsif $player.y != 30 #進むときの処理
        $player = Array_Images.new($player.x, $player.y,"./image/character/player.png",3,4,9)
        $maze["#{($player.y-$masu_posi[1])/30}".to_i]["#{($player.x-$masu_posi[0])/30}".to_i] = 0
        $player.y -= 30
        $feeling_mugon_count = "OFF"
        $feeling_bikkuri_count = "OFF"
        $maze["#{($player.y-$masu_posi[1])/30}".to_i]["#{($player.x-$masu_posi[0])/30}".to_i] = 1
        @SE_get_count = "OFF"
      end
    elsif Input.keyPush?(K_UP) && $maze["#{($player.y-$masu_posi[1])/30}".to_i-1]["#{($player.x-$masu_posi[0])/30}".to_i] == 1 
      $player = Array_Images.new($player.x, $player.y,"./image/character/player.png",3,4,9) #とりあえず向きだけも変える
      @player_direct = "UP"
    end
    
    if Input.keyDown?(K_UP) && $maze["#{($player.y-$masu_posi[1])/30}".to_i-1]["#{($player.x-$masu_posi[0])/30}".to_i] != 1 #マップの先が岩じゃない時
      @player_direct = "UP"
      $move_count += 1
      if $move_count == 15
        $player = Array_Images.new($player.x, $player.y,"./image/character/player.png",3,4,9)
        $maze["#{($player.y-$masu_posi[1])/30}".to_i]["#{($player.x-$masu_posi[0])/30}".to_i] = 0 #プレイヤーの現在地
        $player.y -= 30
        $feeling_mugon_count = "OFF"
        $feeling_bikkuri_count = "OFF"
        $maze["#{($player.y-$masu_posi[1])/30}".to_i]["#{($player.x-$masu_posi[0])/30}".to_i] = 1 #動いた後のプレイヤーの現在地
        $move_count = 0
      end
    elsif Input.keyRelease?(K_UP) && $maze["#{($player.y-$masu_posi[1])/30}".to_i-1]["#{($player.x-$masu_posi[0])/30}".to_i] != 1
      $move_count = 0
    end
    
    #左に進む
    if Input.keyPush?(K_LEFT) && $maze["#{($player.y-$masu_posi[1])/30}".to_i]["#{($player.x-$masu_posi[0])/30}".to_i-1] != 1
      @player_direct = "LEFT"
      if $player.x == 30
        $player = Array_Images.new($player.x, $player.y,"./image/character/player.png",3,4,3)
      else
        $player = Array_Images.new($player.x, $player.y,"./image/character/player.png",3,4,3)
        $maze["#{($player.y-$masu_posi[1])/30}".to_i]["#{($player.x-$masu_posi[0])/30}".to_i] = 0
        $player.x -= 30
        $feeling_mugon_count = "OFF"
        $feeling_bikkuri_count = "OFF"
        $maze["#{($player.y-$masu_posi[1])/30}".to_i]["#{($player.x-$masu_posi[0])/30}".to_i] = 1
        @SE_get_count = "OFF"
      end
    elsif Input.keyPush?(K_LEFT) && $maze["#{($player.y-$masu_posi[1])/30}".to_i]["#{($player.x-$masu_posi[0])/30}".to_i-1] == 1
      @player_direct = "LEFT"
      $player = Array_Images.new($player.x, $player.y,"./image/character/player.png",3,4,3) #とりあえず向きだけも変える
    end
    
    if Input.keyDown?(K_LEFT) && $maze["#{($player.y-$masu_posi[1])/30}".to_i]["#{($player.x-$masu_posi[0])/30}".to_i-1] != 1
      @player_direct = "LEFT"
      $move_count += 1
      if $move_count == 15
        $player = Array_Images.new($player.x, $player.y,"./image/character/player.png",3,4,3)
        $maze["#{($player.y-$masu_posi[1])/30}".to_i]["#{($player.x-$masu_posi[0])/30}".to_i] = 0
        $player.x -= 30
        $feeling_mugon_count = "OFF"
        $feeling_bikkuri_count = "OFF"
        $maze["#{($player.y-$masu_posi[1])/30}".to_i]["#{($player.x-$masu_posi[0])/30}".to_i] = 1
        $move_count = 0
      end
    elsif Input.keyRelease?(K_LEFT) && $maze["#{($player.y-$masu_posi[1])/30}".to_i]["#{($player.x-$masu_posi[0])/30}".to_i-1] != 1
      $move_count = 0
    end
    
    #右に進む
    if Input.keyPush?(K_RIGHT) && $maze["#{($player.y-$masu_posi[1])/30}".to_i]["#{($player.x-$masu_posi[0])/30}".to_i+1] != 1
      @player_direct = "RIGHT"
      if $player.x == 570
        $player = Array_Images.new($player.x, $player.y,"./image/character/player.png",3,4,6)
      else
        $player = Array_Images.new($player.x, $player.y,"./image/character/player.png",3,4,6)
        $maze["#{($player.y-$masu_posi[1])/30}".to_i]["#{($player.x-$masu_posi[0])/30}".to_i] = 0
        $player.x += 30
        $feeling_mugon_count = "OFF"
        $feeling_bikkuri_count = "OFF"
        $maze["#{($player.y-$masu_posi[1])/30}".to_i]["#{($player.x-$masu_posi[0])/30}".to_i] = 1
        @SE_get_count = "OFF"
      end
    elsif Input.keyPush?(K_RIGHT) && $maze["#{($player.y-$masu_posi[1])/30}".to_i]["#{($player.x-$masu_posi[0])/30}".to_i+1] == 1
      @player_direct = "RIGHT"
      $player = Array_Images.new($player.x, $player.y,"./image/character/player.png",3,4,6)
    end
    
    if Input.keyDown?(K_RIGHT) && $maze["#{($player.y-$masu_posi[1])/30}".to_i]["#{($player.x-$masu_posi[0])/30}".to_i+1] != 1
      @player_direct = "RIGHT"
      $move_count += 1
      if $move_count == 15
        $player = Array_Images.new($player.x, $player.y,"./image/character/player.png",3,4,6)
        $maze["#{($player.y-$masu_posi[1])/30}".to_i]["#{($player.x-$masu_posi[0])/30}".to_i] = 0
        $player.x += 30
        $feeling_mugon_count = "OFF"
        $feeling_bikkuri_count = "OFF"
        $maze["#{($player.y-$masu_posi[1])/30}".to_i]["#{($player.x-$masu_posi[0])/30}".to_i] = 1
        $move_count = 0
      end
    elsif Input.keyRelease?(K_RIGHT) && $maze["#{($player.y-$masu_posi[1])/30}".to_i]["#{($player.x-$masu_posi[0])/30}".to_i+1] != 1
      $move_count = 0
    end
    
    #下に進む
    if Input.keyPush?(K_DOWN) && $maze["#{($player.y-$masu_posi[1])/30}".to_i+1]["#{($player.x-$masu_posi[0])/30}".to_i] != 1
      @player_direct = "DOWN"
      if $player.y == 570
        $player = Array_Images.new($player.x, $player.y,"./image/character/player.png",3,4,0)
      else
        $player = Array_Images.new($player.x, $player.y,"./image/character/player.png",3,4,0)
        $maze["#{($player.y-$masu_posi[1])/30}".to_i]["#{($player.x-$masu_posi[0])/30}".to_i] = 0
        $player.y += 30
        $feeling_mugon_count = "OFF"
        $feeling_bikkuri_count = "OFF"
        $maze["#{($player.y-$masu_posi[1])/30}".to_i]["#{($player.x-$masu_posi[0])/30}".to_i] = 1
        @SE_get_count = "OFF"
      end
    elsif Input.keyPush?(K_DOWN) && $maze["#{($player.y-$masu_posi[1])/30}".to_i+1]["#{($player.x-$masu_posi[0])/30}".to_i] == 1
      @player_direct = "DOWN"
      $player = Array_Images.new($player.x, $player.y,"./image/character/player.png",3,4,0)
    end
    
    if Input.keyDown?(K_DOWN) && $maze["#{($player.y-$masu_posi[1])/30}".to_i+1]["#{($player.x-$masu_posi[0])/30}".to_i] != 1
      @player_direct = "DOWN"
      $move_count += 1
      if $move_count == 15
        $player = Array_Images.new($player.x, $player.y,"./image/character/player.png",3,4,0)
        $maze["#{($player.y-$masu_posi[1])/30}".to_i]["#{($player.x-$masu_posi[0])/30}".to_i] = 0
        $player.y += 30
        $feeling_mugon_count = "OFF"
        $feeling_bikkuri_count = "OFF"
        $maze["#{($player.y-$masu_posi[1])/30}".to_i]["#{($player.x-$masu_posi[0])/30}".to_i] = 1
        $move_count = 0
      end
    elsif Input.keyRelease?(K_DOWN) && $maze["#{($player.y-$masu_posi[1])/30}".to_i+1]["#{($player.x-$masu_posi[0])/30}".to_i] != 1
      $move_count = 0
    end
end #処理落ち回避のため
  end #update
  
  def player_render
  
  end #render
end #scene
##################################################################
