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
#$monster_SE  = Sound.new("./lib/sound/hitting1.wav")
#$player_SE  = Sound.new("./lib/sound/kick1.wav")
$seikai_SE  = Sound.new("./lib/sound/seikai.wav")
$matigai_SE  = Sound.new("./lib/sound/matigai.wav")
$clear_SE  = Sound.new("./lib/sound/clear.mid")
$player_SE  = Sound.new("./lib/sound/kick1.wav")
$monster_SE  = Sound.new("./lib/sound/hitting1.wav")
$get_SE  = Sound.new("./lib/sound/get.wav")
$get_SE2  = Sound.new("./lib/sound/get2.wav")
#####################################################################
class Init_Scene  < Scene::Base
  #タイトル画面の諸々の定義　↓ここから↓
  def hit_init
    @key_get = Images.new(20*30+60+$masu_posi[0], $masu_posi[1], 100, 100, "", 24, Gray, Black)
    @key_on_count = 0
    @takarabako_color = [Red,Blue,Yellow,Pink,Green]
    @SE_get_count = "OFF"
##########################武器の状態
    #@item_window = Images.new(@height*30+50+$masu_posi[0], $masu_posi[1]+150, 250, 450, "", 24, Gray, Black)
    #@item_window.image("./image/frame4.png")
    #$weapon_state = $key_teiji[1][@rand] #@takarabako_color[@r]
    #$weapon_message = Images.new(@height*30+50+$masu_posi[0], $masu_posi[1]+150, 100, 100, "メッセージ", 24, Gray, Black)
    #@weapon_message  = Images.new(@height*30+200+$masu_posi[0], $masu_posi[1], 100, 100, "", 24, Gray, Black)
    #@item_window = Images.new(@height*30+50+$masu_posi[0], $masu_posi[1]+150, 250, 450, "", 24, Gray, Black)
    @weapon_message = Fonts.new(@height*30+60+$masu_posi[0], $masu_posi[1]+170, "　 は 　によわい", 30, White)
    @weapon_message1 = Images.new(@height*30+60+$masu_posi[0],$masu_posi[1]+170,1,1) #対象
    @weapon_message2 = Images.new(@height*30+120+$masu_posi[0],$masu_posi[1]+170,1,1) #武器
    @weapon_state = nil
##########################自身の体力
    @heart_img = Array.new
    p @heart_count = $heart_number #これでちゃんとはいっている
    @heart_message = Fonts.new(@height*30+60+$masu_posi[0], $masu_posi[1]+180, "ライフ", 30, White)
    for i in 1..$heart_number
      @heart_img[i] = Images.new(@height*30+60+$masu_posi[0]+40*(i-1),$masu_posi[1]+220,30,30) #対象
      @heart_img[i].image("./image/heart/heart_full.png")
    end
##########################ゲームクリアまでのカウント
    @clear_gage_img = Array.new
    @clear_gage_count = $takarabako_number+1
    @clear_gage_message = Fonts.new(@height*30+60+$masu_posi[0], $masu_posi[1]+300, "ゲームクリアまで", 30, White)
    @gage_full_count = 0
    @open_count = Array.new
    for i in 1..@clear_gage_count
      @clear_gage_img[i] = Images.new(@height*30+60+$masu_posi[0]+40*(i-1),$masu_posi[1]+340,30,30) #対象
      @clear_gage_img[i].image("./image/clear_gage/gage_lost_30.png")
    end
    
    #ここを変える？
    for i in 0..$takarabako_number
      @open_count[i] = "OFF" #同じ宝箱が二回開かないようにするもの
    end
##########################攻撃のアニメエフェクト
    $player_damage_effect = Array_Images.new(100, 100,"./image/effect/damage_effect.png",1,2,0)#１は黄のダメージ プレイヤーが与えるダメージ
    $player_damage_flag = "OFF" #プレイヤーが与える
    $monster_damage_effect = Array_Images.new(100, 70,"./image/effect/damage_effect2.png",1,2,0)#２は紫のダメージ モンスターが与えるダメージ
    $monster_damage_flag = "OFF"
    @player_direct = "OFF"
    $player_damage_count = 0
    $monster_damage_count = 0
    #@feeling = Array_Images.new(@img[@height-1][@height-1].x, @img[@height-1][@height-1].y,"./image/effect/damage_effect2.png",1,2,0) #宝箱を取ったときの
    #@img[@height-1][@height-1] 宝箱の位置
    $feeling_bikkuri = Array_Images.new(100,100,"./image/feeling/bikkuri_feeling.png",3,1,0)
    $feeling_bikkuri_count = "OFF"
    $feeling_mugon = Array_Images.new(100,100,"./image/feeling/mugon_feeling.png",3,1,0)
    $feeling_mugon_count = "OFF"
    @open_key = nil
########################モンスターの復活
    $trace_monster_state = Array.new
    $trace_monster_alive_count = Array.new
    $trace_monster_alive_limit = 500 #モンスターが倒されてからこの時間たてば復活
    for i in 1..$trace_monster_number
      $trace_monster_state[i] = "ALIVE" #キャラクターの生死
      $trace_monster_alive_count[i] = 0 #キャラクターの復活のカウント
    end
    #$monster_posi_x =[0,510,30,510,270,270,30,270,510]
    #$monster_posi_y =[0,30,510,510,270,30,270,510,270]
########################モンスターの復活
  end #init
  
  def hit_update
    #武器に触れた時の処理
    for i in 0..$weapon_number
      if @weapon[i].x == $player.x && @weapon[i].y == $player.y && @SE_get_count == "OFF"
        $file.puts "武器をとった,時間,#{S_Timer.get}"
        @weapon_window.image("./image/weapon_90/item_#{i}.png")
        @weapon_message1.image("./image/character3/monster.png")#対象
        @weapon_message2.image("./image/weapon_30/item_#{i}.png")#武器
        @weapon_state = i
        @SE_get_count = "ON"
        $get_SE.play if $BGM_state[0][0] == "ON"
        #武器に触れた時に飛ばす処理
        for j in 0..$weapon_number
          @weapon[j].x = @weapon_x[j]
          @weapon[j].y = @weapon_y[j]
        end
        @weapon[i].x += 1000
        @weapon[i].y += 1000
      end
    end
    
    #p $monster[i].x
    
    #カギと接触した時の条件
    for i in 0..$key_number
      if $player.x == @item[i].x && $player.y == @item[i].y && @SE_get_count == "OFF"
        $file.puts "カギををとった,時間,#{S_Timer.get}"
        @key_on_count = 1
        $get_SE2.play if $BGM_state[0][0] == "ON"
        @SE_get_count = "ON"
        @key_get.image("./image/key3/#{$key_color[i]}.png")
        $key_state = @takarabako_color[i]
        case $key_state
        when Red
          @open_key = "red"
        when Blue
          @open_key = "blue"
        when Yellow
          @open_key = "yellow"
        when Pink
          @open_key = "pink"
        when Green
          @open_key = "green"
        end
        
        
        #カギに触れた時に飛ばす処理
        for j in 0..$key_number
          @item[j].x = @item_x[j]
          @item[j].y = @item_y[j]
        end
        @item[i].x += 1000
        @item[i].y += 1000
      end
    end
    
    #宝箱に接触した時の条件
#=begin
#@treasure_player_posi_x = [30,0,30,30,0]
#@treasure_player_posi_y = [0,30,0,0,30]
#@trasure_direct = ["RIGHT","DOWN","RIGHT","RIGHT","DOWN"] #宝箱のほうに向いている時に開く
p $BGM_state[0][0]
if Input.keyPush?(K_O) #Oを入力したら鍵が開くOPEN
for i in 0..$takarabako_number
    if @img[@treasurebox_posi_x[i]][@treasurebox_posi_y[i]].x == $player.x && @img[@treasurebox_posi_x[i]][@treasurebox_posi_y[i]].y == $player.y
      if $key_state == $key_teiji[1][i] && @open_count[i] == "OFF" #@takarabako_color[@r] 正しい時
        $feeling_bikkuri.x = $player.x
        $feeling_bikkuri.y = $player.y - 30
#=begin #宝箱を開けたことにしとく処理
        case $takarabako_teiji[1][i]
        when Red
          @img[@treasurebox_posi_x[i]][@treasurebox_posi_y[i]].image("./image/takarabako_30_open/takarabako_red.png")
        when Blue
          @img[@treasurebox_posi_x[i]][@treasurebox_posi_y[i]].image("./image/takarabako_30_open/takarabako_blue.png")
        when Yellow
          @img[@treasurebox_posi_x[i]][@treasurebox_posi_y[i]].image("./image/takarabako_30_open/takarabako_yellow.png")
        when Pink
          @img[@treasurebox_posi_x[i]][@treasurebox_posi_y[i]].image("./image/takarabako_30_open/takarabako_purple.png")
        when Green
          @img[@treasurebox_posi_x[i]][@treasurebox_posi_y[i]].image("./image/takarabako_30_open/takarabako_green.png")
        end
#=end
        if $feeling_bikkuri_count == "OFF"
          p 72146094692046
          if $BGM_state[0][0] == "ON"
            $seikai_SE.play
            @open_count[i] = "ON" #同じ宝箱が二回開かないようにするもの
            p @gage_full_count += 1 #gageを増やす処理を入れる
            for i in 1..@gage_full_count
              @clear_gage_img[i].image("./image/clear_gage/gage_full_30.png") #超えたらだめだからフルになったところでゲームクリアにする
            end
          end
        end
        $file.puts "クリア,時間,#{S_Timer.get},開けたカギ,#{@open_key}" if $feeling_bikkuri_count == "OFF"
        $feeling_bikkuri_count = "ON"
        #@game_clear_count = "ON"
        #clear_update
        
      elsif $key_state != $key_teiji[1][i] #&& @open_count[i] == "OFF" #間違った時
        $file.puts "間違い,,#{S_Timer.get},間違えたカギ,#{@open_key}" if $feeling_mugon_count == "OFF"
        if $feeling_mugon_count == "OFF"
          if $BGM_state[0][0] == "ON"
            $matigai_SE.play 
          end
        end
        $feeling_mugon_count = "ON"
        $feeling_mugon.x = $player.x
        $feeling_mugon.y = $player.y - 30
      end
    end
  end
end #カギを開くボタンの入力

    if @gage_full_count == @clear_gage_count
      p 9999
      @game_clear_count = "ON"
      clear_update
    end
#=end

    #宝箱に接触した時の条件
=begin
    if @img[@height-1][@height-1].x == $player.x && @img[@height-1][@height-1].y == $player.y
      if $key_state == $key_teiji[1][@rand] #@takarabako_color[@r] 正しい時
        $feeling_bikkuri.x = $player.x
        $feeling_bikkuri.y = $player.y - 30
        if $feeling_bikkuri_count == "OFF"
          if $BGM_state[0][0] == "ON"
            $seikai_SE.play
          end
        end
        $file.puts "クリア,時間,#{S_Timer.get},開けたカギ,#{@open_key}" if $feeling_bikkuri_count == "OFF"
        $feeling_bikkuri_count = "ON"
        @game_clear_count = "ON"
        clear_update
      elsif $key_state != $key_teiji[1][@rand] #間違った時
        $file.puts "間違い,,#{S_Timer.get},間違えたカギ,#{@open_key}" if $feeling_mugon_count == "OFF"
        if $feeling_mugon_count == "OFF"
          if $BGM_state[0][0] == "ON"
            $matigai_SE.play 
          end
        end
        $feeling_mugon_count = "ON"
        $feeling_mugon.x = $player.x
        $feeling_mugon.y = $player.y - 30
      end
    end
=end


    #武器に接触した時の条件
=begin
    for i in 0..$weapon_number
      if @weapon[i].x == $player.x && @weapon[i].y == $player.y
        @weapon_window.image("./image/weapon_90/item_#{i}.png")
        #$get_SE.play
    end
=end
    
#=begin
    
    
    
    
#進んだ時の判定

#上に進んだとき 追跡する敵
#ダメージのフラグ
    #$monster_damage_flag = "OFF"
    #$player_damage_count = 0
#=begin バグの元
    if $player_damage_flag == "ON"
      $player_move_stop = "ON"
      $player_damage_count += 1
      if $player_damage_count == 5
        $player_damage_effect.n += 1
        #$player_damage_effect
        $player.y -= 10 if @player_direct == "UP"
        $player.y += 10 if @player_direct == "DOWN"
        $player.x -= 10 if @player_direct == "LEFT"
        $player.x += 10 if @player_direct == "RIGHT"
      elsif $player_damage_count == 10
        $player.y += 10 if @player_direct == "UP"
        $player.y -= 10 if @player_direct == "DOWN"
        $player.x += 10 if @player_direct == "LEFT"
        $player.x -= 10 if @player_direct == "RIGHT"
        #$monster.y += 10
        $player_damage_effect.n = 0
        $player_damage_count = 0
        $player_damage_flag = "OFF"
        $player_move_stop = "OFF"
      end
    end
#=end
    
    
    
#########################################以下に攻撃の処理を書いている
#=begin
#上に進んだとき 追跡する敵
#=begin
    if Input.keyPush?(K_SPACE) && @weapon_state != nil && @player_direct == "UP"
      p 88 #ここまでは入る
      $feeling_bikkuri_count = "OFF"
      $feeling_mugon_count = "OFF"
      for i in 1..$trace_monster_number
        if $player.x == $monster[i].x && $player.y == $monster[i].y + 30
          p 77777777
          $maze["#{($monster[i].y-$masu_posi[1])/30}".to_i]["#{($monster[i].x-$masu_posi[0])/30}".to_i] = 0
          $trace_monster_state[i] = "DEAD" #キャラクターの生死
          $file.puts "上にいる敵を倒した,,#{S_Timer.get}"
          $player_damage_effect.x = $monster[i].x
          $player_damage_effect.y = $monster[i].y
          $player_damage_flag = "ON"
          $player_SE.play if $BGM_state[0][0] == "ON"
          $monster[i].y = 1280
          $monster[i].x = 1280
          #$player_damage_effect.x = $player.x
          #$player_damage_effect.y =$player.y - 30
          $player = Array_Images.new($player.x, $player.y,"./image/character/player.png",3,4,9)
          #武器に関するところ↓
          @weapon_window.image("./image/weapon_90/item_window2.png") #武器の所持のイメージ
          @weapon_state = nil #武器の所持状態
          for j in 0..$weapon_number #武器の場所を元に戻す
            @weapon[j].x = @weapon_x[j]
            @weapon[j].y = @weapon_y[j]
          end
          #武器に関するところ↑
        end
      end
    end
#=end
    

#下に進んだとき 追跡する敵
#=begin
    if Input.keyPush?(K_SPACE) && @weapon_state != nil && @player_direct == "DOWN"
      p 88
      $feeling_bikkuri_count = "OFF"
      $feeling_mugon_count = "OFF"
      #追跡する敵に接触した時の条件 
      for i in 1..$trace_monster_number
        if $player.x == $monster[i].x && $player.y == $monster[i].y - 30
          p 77777777
          $maze["#{($monster[i].y-$masu_posi[1])/30}".to_i]["#{($monster[i].x-$masu_posi[0])/30}".to_i] = 0 #ここでモンスターのいる位置が０になる
          $trace_monster_state[i] = "DEAD" #キャラクターの生死
          $file.puts "下にいる敵を倒した,,#{S_Timer.get}"
          $player_damage_effect.x = $monster[i].x
          $player_damage_effect.y = $monster[i].y
          $player_damage_flag = "ON"
          $player_SE.play if $BGM_state[0][0] == "ON"
          $monster[i].y = 1280
          $monster[i].x = 1280
          #$player_damage_effect.x = $player.x
          #$player_damage_effect.y =$player.y - 30
          $player = Array_Images.new($player.x, $player.y,"./image/character/player.png",3,4,0)
          #武器に関するところ↓
          @weapon_window.image("./image/weapon_90/item_window2.png") #武器の所持のイメージ
          @weapon_state = nil #武器の所持状態
          for j in 0..$weapon_number #武器の場所を元に戻す
            @weapon[j].x = @weapon_x[j]
            @weapon[j].y = @weapon_y[j]
          end
          #武器に関するところ↑
        end
      end
    end
#=end

#右に進んだとき 追跡する敵
#=begin
    if Input.keyPush?(K_SPACE) && @weapon_state != nil && @player_direct == "RIGHT"
      p 88
      $feeling_bikkuri_count = "OFF"
      $feeling_mugon_count = "OFF"
      #追跡する敵に接触した時の条件 
      for i in 1..$trace_monster_number
        if $player.y == $monster[i].y && $player.x == $monster[i].x - 30
          p 77777777
          $maze["#{($monster[i].y-$masu_posi[1])/30}".to_i]["#{($monster[i].x-$masu_posi[0])/30}".to_i] = 0
          $trace_monster_state[i] = "DEAD" #キャラクターの生死
          $file.puts "右にいる敵を倒した,,#{S_Timer.get}"
          $player_damage_effect.x = $monster[i].x
          $player_damage_effect.y = $monster[i].y
          $player_damage_flag = "ON"
          $player_SE.play if $BGM_state[0][0] == "ON"
          $monster[i].y = 1280
          $monster[i].x = 1280
          #$player_damage_effect.x = $player.x
          #$player_damage_effect.y =$player.y - 30
          $player = Array_Images.new($player.x, $player.y,"./image/character/player.png",3,4,6)
          #武器に関するところ↓
          @weapon_window.image("./image/weapon_90/item_window2.png") #武器の所持のイメージ
          @weapon_state = nil #武器の所持状態
          for j in 0..$weapon_number #武器の場所を元に戻す
            @weapon[j].x = @weapon_x[j]
            @weapon[j].y = @weapon_y[j]
          end
          #武器に関するところ↑
        end
      end
    end
#=end

#左に進んだとき 追跡する敵
#=begin
    if Input.keyPush?(K_SPACE) && @weapon_state != nil && @player_direct == "LEFT"
      p 88
      $feeling_bikkuri_count = "OFF"
      $feeling_mugon_count = "OFF"
      #追跡する敵に接触した時の条件 
      for i in 1..$trace_monster_number
        if $player.y == $monster[i].y && $player.x == $monster[i].x + 30
          p 77777777
          $maze["#{($monster[i].y-$masu_posi[1])/30}".to_i]["#{($monster[i].x-$masu_posi[0])/30}".to_i] = 0
          $trace_monster_state[i] = "DEAD" #キャラクターの生死
          $file.puts "左にいる敵を倒した,,#{S_Timer.get}"
          $player_damage_effect.x = $monster[i].x
          $player_damage_effect.y = $monster[i].y
          @player_direct = "LEFT"
          $player_damage_flag = "ON"
          $player_SE.play if $BGM_state[0][0] == "ON"
          $monster[i].y = 1280
          $monster[i].x = 1280
          $player = Array_Images.new($player.x, $player.y,"./image/character/player.png",3,4,3)
          #$player_damage_effect.x = $player.x
          #$player_damage_effect.y =$player.y - 30
          $player = Array_Images.new($player.x, $player.y,"./image/character/player.png",3,4,3)
          #武器に関するところ↓
          @weapon_window.image("./image/weapon_90/item_window2.png") #武器の所持のイメージ
          @weapon_state = nil #武器の所持状態
          for j in 0..$weapon_number #武器の場所を元に戻す
            @weapon[j].x = @weapon_x[j]
            @weapon[j].y = @weapon_y[j]
          end
          #武器に関するところ↑
        end
      end
    end
#=end
#########################################敵の復活の処理↓
    for i in 1..$trace_monster_number
      if $trace_monster_state[i] == "DEAD" #キャラクターの生死
        $trace_monster_alive_count[i] += 1 #キャラクターの復活のカウント
      end
      
      if $trace_monster_alive_count[i] >= $trace_monster_alive_limit
        #プレイヤーのいるところでは復活しないようにする
        $monster[i].x = $monster_posi_x[i]+$masu_posi[0]
        $monster[i].y = $monster_posi_y[i]+$masu_posi[1]
        $trace_monster_state[i] = "ALIVE"
        $trace_monster_alive_count[i] = 0
      end
    #$trace_monster_alive_count[i] = 0 #キャラクターの復活のカウント
    #$trace_monster_alive_limit = 100 #モンスターが倒されてからこの時間たてば復活
    end
#########################################敵の復活の処理↑
    #ランダムに動く敵
    for i in $trace_monster_number..$random_monster_number #ここのところ簡単にする ランダムに動く敵に衝突した時
      if $player.x == $monster2[i+1].x && $player.y == $monster2[i+1] .y
        @key_get.image("./image/item_window2.png")
      end
    end
=begin
    #敵に接触した時の条件
    for i in 1..$trace_monster_number
      if $player.x == $monster[i].x && $player.y == $monster[i].y
        p 99999
      end
    end
=end
    
  end #update
  
  def hit_render
    if @key_on_count == 1 #カギの状態
      @key_get.render
    end
    
    if $player_damage_flag == "ON" 
      $player_damage_effect.render
    end
    
    if $monster_damage_flag == "ON"
      $monster_damage_effect.render
    end
    
    if $feeling_bikkuri_count == "ON"
      $feeling_bikkuri.render
    end
    
    if $feeling_mugon_count == "ON"
      $feeling_mugon.render
    end
    
##########################自身の体力
    @heart_message.render
    for i in 1..$heart_number
      @heart_img[i].render
    end
##########################ゲームクリアまでのカウント
    @clear_gage_message.render
#=begin
    for i in 1..@clear_gage_count
      @clear_gage_img[i].render
    end
#=end
##########################
  end #render
end #scene
##################################################################
