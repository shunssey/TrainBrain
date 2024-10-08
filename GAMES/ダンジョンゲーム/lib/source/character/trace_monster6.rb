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
###############音楽
$player_SE  = Sound.new("./lib/sound/kick1.wav")
$monster_SE  = Sound.new("./lib/sound/hitting1.wav")
###############

class Init_Scene  < Scene::Base
  
  #タイトル画面の諸々の定義↓ここから↓
  def trace_monster_init
    $trace_monster_move_count = Array.new
    for i in 1..$trace_monster_number
      $trace_monster_move_count[i] = 0 #キャラクターの移動のカウント
    end
    $trace_monster_move_count2 = 50 #キャラクターがこのカウントより大きくなった時に動き出す。大きくすれば遅くなる
    $monster_direct = 0
##########################攻撃のアニメエフェクト
    $player_damage_effect = Array_Images.new(100, 100,"./image/effect/damage_effect.png",1,2,0)#１は黄のダメージ プレイヤーが与えるダメージ
    $player_damage_flag = "OFF" #プレイヤーが与える
    $monster_damage_effect = Array_Images.new(100, 70,"./image/effect/damage_effect2.png",1,2,0)#２は紫のダメージ モンスターが与えるダメージ
    $monster_damage_flag = "OFF"
    $player_damage_count = 0
    $monster_damage_count = 0
    $trace_monster_direct = Array.new
    #$trace_monster_direct = "OFF"
    $trace_monster_direct_count = 1
    #$monster_direct = "OFF"
  end #init
  
  def trace_monster_update
    if $monster_damage_flag == "ON"
      $monster_damage_count += 1
      if $monster_damage_count == 5
        $monster_damage_effect.n += 1
        for i in 1..$trace_monster_number #ここの処理がおかしい？
          $monster[i].y -= 10 if $trace_monster_direct[i] == "UP"
          $monster[i].y += 10 if $trace_monster_direct[i] == "DOWN"
          $monster[i].x -= 10 if $trace_monster_direct[i] == "LEFT"
          $monster[i].x += 10 if $trace_monster_direct[i] == "RIGHT"
        end
      elsif $monster_damage_count == 10
        for i in 1..$trace_monster_number #for
          $monster[i].y += 10 if $trace_monster_direct[i] == "UP"
          $monster[i].y -= 10 if $trace_monster_direct[i] == "DOWN"
          $monster[i].x += 10 if $trace_monster_direct[i] == "LEFT"
          $monster[i].x -= 10 if $trace_monster_direct[i] == "RIGHT"
        end
          $monster_damage_effect.n = 0
          $monster_damage_count = 0
          $monster_damage_flag = "OFF"
        end
      end
    #end
#追いかける
    for i in 1..$trace_monster_number #for
      $trace_monster_move_count[i] += 1
      if $trace_monster_move_count[i] > $trace_monster_move_count2
        if $player.x != $monster[i].x #横の座標に差があるとき #"#{($monster[i].y-$masu_posi[1])/30}" 横に移動する
          #左に移動する
          if $player.x <= $monster[i].x && $maze["#{($monster[i].y-$masu_posi[1])/30}".to_i]["#{($monster[i].x-$masu_posi[0])/30}".to_i-1] != 1 #左に進む
            #if $player.x + 30 != $monster[i].x && ($player.y == $monster[i].y) 
            $monster[i] = Array_Images.new($monster[i].x, $monster[i].y,"./image/character/monster1.png",3,4,3)
            $maze["#{($monster[i].y-$masu_posi[1])/30}".to_i]["#{($monster[i].x-$masu_posi[0])/30}".to_i] = 0
            $monster[i].x -= 30 
            $maze["#{($monster[i].y-$masu_posi[1])/30}".to_i]["#{($monster[i].x-$masu_posi[0])/30}".to_i] = 1
            $trace_monster_move_count[i] = 0
            #end 
          #右に移動する
          elsif $player.x >= $monster[i].x && $maze["#{($monster[i].y-$masu_posi[1])/30}".to_i]["#{($monster[i].x-$masu_posi[0])/30}".to_i+1] != 1 #右に進む
            $monster[i] = Array_Images.new($monster[i].x, $monster[i].y,"./image/character/monster1.png",3,4,6)
            $maze["#{($monster[i].y-$masu_posi[1])/30}".to_i]["#{($monster[i].x-$masu_posi[0])/30}".to_i] = 0
            $monster[i].x += 30
            $maze["#{($monster[i].y-$masu_posi[1])/30}".to_i]["#{($monster[i].x-$masu_posi[0])/30}".to_i] = 1
            $trace_monster_move_count[i] = 0
          #敵に攻撃するとき
          elsif $player.y == $monster[i].y && $player.x == $monster[i].x + 30 #右にいるモンスターが左に攻撃
            $monster[i] = Array_Images.new($monster[i].x, $monster[i].y,"./image/character/monster1.png",3,4,6)
            p $trace_monster_direct[i] = "RIGHT"
            p $heart_number -= 1
            $file.puts "敵から攻撃を受けた,時間,#{S_Timer.get}"
            $monster_SE.play if $BGM_state[0][0] == "ON"
            @key_get.image("./image/item_window2.png")
            #カギを戻すもの
            for j in 0..$key_number
              @item[j].x = @item_x[j]
              @item[j].y = @item_y[j]
            end
            #end
            $monster_damage_effect = Array_Images.new($player.x, $player.y,"./image/effect/damage_effect2.png",1,2,0)
            $monster_damage_flag = "ON"
            $trace_monster_move_count[i] = 0
            $key_state = nil
          elsif $player.y == $monster[i].y && $player.x == $monster[i].x - 30 #左にいるモンスターが右に攻撃
            $monster[i] = Array_Images.new($monster[i].x, $monster[i].y,"./image/character/monster1.png",3,4,3)
            p $trace_monster_direct[i] = "LEFT"
            p $heart_number -= 1
            $monster_SE.play if $BGM_state[0][0] == "ON"
            $file.puts "敵から攻撃を受けた,時間,#{S_Timer.get}"
            @key_get.image("./image/item_window2.png")
            #カギを戻すもの
            for j in 0..$key_number
              @item[j].x = @item_x[j]
              @item[j].y = @item_y[j]
            end
            #end
            $monster_damage_effect = Array_Images.new($player.x, $player.y,"./image/effect/damage_effect2.png",1,2,0)
            $monster_damage_flag = "ON"
            $trace_monster_move_count[i] = 0
            $key_state = nil
          end
        end
        
        if $player.y != $monster[i].y #縦の座標に差があるとき 縦に移動する
          if $player.y <= $monster[i].y && $maze["#{($monster[i].y-$masu_posi[1])/30}".to_i-1]["#{($monster[i].x-$masu_posi[0])/30}".to_i] != 1 #&& $monster[i].y != 2000 #上に進む $maze["#{($monster[i].y-$masu_posi[1])/30}".to_i-1]["#{($monster[i].x-$masu_posi[0])/30}".to_i] != 1 これがおかしい
            #上に行く
            $monster[i] = Array_Images.new($monster[i].x, $monster[i].y,"./image/character/monster1.png",3,4,9)
            $maze["#{($monster[i].y-$masu_posi[1])/30}".to_i]["#{($monster[i].x-$masu_posi[0])/30}".to_i] = 0
            $monster[i].y -= 30
            $maze["#{($monster[i].y-$masu_posi[1])/30}".to_i]["#{($monster[i].x-$masu_posi[0])/30}".to_i] = 1
            $trace_monster_move_count[i] = 0
          elsif $player.y >= $monster[i].y && $maze["#{($monster[i].y-$masu_posi[1])/30}".to_i+1]["#{($monster[i].x-$masu_posi[0])/30}".to_i] != 1 #&& $monster[i].y != 2000 #下に進む
            #下に行く
            $monster[i] = Array_Images.new($monster[i].x, $monster[i].y,"./image/character/monster1.png",3,4,0)
            $maze["#{($monster[i].y-$masu_posi[1])/30}".to_i]["#{($monster[i].x-$masu_posi[0])/30}".to_i] = 0
            $monster[i].y += 30
            $maze["#{($monster[i].y-$masu_posi[1])/30}".to_i]["#{($monster[i].x-$masu_posi[0])/30}".to_i] = 1
            $trace_monster_move_count[i] = 0
          #敵が攻撃するとき
          elsif $player.x == $monster[i].x && $player.y == $monster[i].y + 30 #上にいるモンスターが下に攻撃
            $monster[i] = Array_Images.new($monster[i].x, $monster[i].y,"./image/character/monster1.png",3,4,0)
            p $trace_monster_direct[i] = "DOWN"
            p $heart_number -= 1
            $file.puts "敵から攻撃を受けた,時間,#{S_Timer.get}"
            $monster_SE.play if $BGM_state[0][0] == "ON"
            @key_get.image("./image/item_window2.png")
            #カギを戻すもの
            for j in 0..$key_number
              @item[j].x = @item_x[j]
              @item[j].y = @item_y[j]
            end
            #end
            $monster_damage_effect = Array_Images.new($player.x, $player.y,"./image/effect/damage_effect2.png",1,2,0)
            $monster_damage_flag = "ON"
            $trace_monster_move_count[i] = 0
            $key_state = nil
          elsif $player.x == $monster[i].x && $player.y == $monster[i].y - 30 #下にいるモンスターが上に攻撃
            $monster[i] = Array_Images.new($monster[i].x, $monster[i].y,"./image/character/monster1.png",3,4,9)
            p $trace_monster_direct[i] = "UP"
            p $heart_number -= 1
            $monster_SE.play if $BGM_state[0][0] == "ON"
            $file.puts "敵から攻撃を受けた,時間,#{S_Timer.get}"
            @key_get.image("./image/item_window2.png")
            #カギを戻すもの
            for j in 0..$key_number
              @item[j].x = @item_x[j]
              @item[j].y = @item_y[j]
            end
            #end
            $monster_damage_effect = Array_Images.new($player.x, $player.y,"./image/effect/damage_effect2.png",1,2,0)
            $monster_damage_flag = "ON"
            $trace_monster_move_count[i] = 0
            $key_state = nil
          end
        end
      end
    end#for
  end #update
  
  def trace_monster_render
    
  end #render
end #scene
##################################################################
