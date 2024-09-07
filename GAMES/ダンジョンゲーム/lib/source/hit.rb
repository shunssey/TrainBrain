# scene���W���[��������ɉ���
# ��{�f�[�^�̒ǋL
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
  #�^�C�g����ʂ̏��X�̒�`�@���������火
  def hit_init
    @key_get = Images.new(20*30+60+$masu_posi[0], $masu_posi[1], 100, 100, "", 24, Gray, Black)
    @key_on_count = 0
    @takarabako_color = [Red,Blue,Yellow,Pink,Green]
    @SE_get_count = "OFF"
##########################����̏��
    #@item_window = Images.new(@height*30+50+$masu_posi[0], $masu_posi[1]+150, 250, 450, "", 24, Gray, Black)
    #@item_window.image("./image/frame4.png")
    #$weapon_state = $key_teiji[1][@rand] #@takarabako_color[@r]
    #$weapon_message = Images.new(@height*30+50+$masu_posi[0], $masu_posi[1]+150, 100, 100, "���b�Z�[�W", 24, Gray, Black)
    #@weapon_message  = Images.new(@height*30+200+$masu_posi[0], $masu_posi[1], 100, 100, "", 24, Gray, Black)
    #@item_window = Images.new(@height*30+50+$masu_posi[0], $masu_posi[1]+150, 250, 450, "", 24, Gray, Black)
    @weapon_message = Fonts.new(@height*30+60+$masu_posi[0], $masu_posi[1]+170, "�@ �� �@�ɂ�킢", 30, White)
    @weapon_message1 = Images.new(@height*30+60+$masu_posi[0],$masu_posi[1]+170,1,1) #�Ώ�
    @weapon_message2 = Images.new(@height*30+120+$masu_posi[0],$masu_posi[1]+170,1,1) #����
    @weapon_state = nil
##########################���g�̗̑�
    @heart_img = Array.new
    p @heart_count = $heart_number #����ł����Ƃ͂����Ă���
    @heart_message = Fonts.new(@height*30+60+$masu_posi[0], $masu_posi[1]+180, "���C�t", 30, White)
    for i in 1..$heart_number
      @heart_img[i] = Images.new(@height*30+60+$masu_posi[0]+40*(i-1),$masu_posi[1]+220,30,30) #�Ώ�
      @heart_img[i].image("./image/heart/heart_full.png")
    end
##########################�Q�[���N���A�܂ł̃J�E���g
    @clear_gage_img = Array.new
    @clear_gage_count = $takarabako_number+1
    @clear_gage_message = Fonts.new(@height*30+60+$masu_posi[0], $masu_posi[1]+300, "�Q�[���N���A�܂�", 30, White)
    @gage_full_count = 0
    @open_count = Array.new
    for i in 1..@clear_gage_count
      @clear_gage_img[i] = Images.new(@height*30+60+$masu_posi[0]+40*(i-1),$masu_posi[1]+340,30,30) #�Ώ�
      @clear_gage_img[i].image("./image/clear_gage/gage_lost_30.png")
    end
    
    #������ς���H
    for i in 0..$takarabako_number
      @open_count[i] = "OFF" #�����󔠂����J���Ȃ��悤�ɂ������
    end
##########################�U���̃A�j���G�t�F�N�g
    $player_damage_effect = Array_Images.new(100, 100,"./image/effect/damage_effect.png",1,2,0)#�P�͉��̃_���[�W �v���C���[���^����_���[�W
    $player_damage_flag = "OFF" #�v���C���[���^����
    $monster_damage_effect = Array_Images.new(100, 70,"./image/effect/damage_effect2.png",1,2,0)#�Q�͎��̃_���[�W �����X�^�[���^����_���[�W
    $monster_damage_flag = "OFF"
    @player_direct = "OFF"
    $player_damage_count = 0
    $monster_damage_count = 0
    #@feeling = Array_Images.new(@img[@height-1][@height-1].x, @img[@height-1][@height-1].y,"./image/effect/damage_effect2.png",1,2,0) #�󔠂�������Ƃ���
    #@img[@height-1][@height-1] �󔠂̈ʒu
    $feeling_bikkuri = Array_Images.new(100,100,"./image/feeling/bikkuri_feeling.png",3,1,0)
    $feeling_bikkuri_count = "OFF"
    $feeling_mugon = Array_Images.new(100,100,"./image/feeling/mugon_feeling.png",3,1,0)
    $feeling_mugon_count = "OFF"
    @open_key = nil
########################�����X�^�[�̕���
    $trace_monster_state = Array.new
    $trace_monster_alive_count = Array.new
    $trace_monster_alive_limit = 500 #�����X�^�[���|����Ă��炱�̎��Ԃ��ĂΕ���
    for i in 1..$trace_monster_number
      $trace_monster_state[i] = "ALIVE" #�L�����N�^�[�̐���
      $trace_monster_alive_count[i] = 0 #�L�����N�^�[�̕����̃J�E���g
    end
    #$monster_posi_x =[0,510,30,510,270,270,30,270,510]
    #$monster_posi_y =[0,30,510,510,270,30,270,510,270]
########################�����X�^�[�̕���
  end #init
  
  def hit_update
    #����ɐG�ꂽ���̏���
    for i in 0..$weapon_number
      if @weapon[i].x == $player.x && @weapon[i].y == $player.y && @SE_get_count == "OFF"
        $file.puts "������Ƃ���,����,#{S_Timer.get}"
        @weapon_window.image("./image/weapon_90/item_#{i}.png")
        @weapon_message1.image("./image/character3/monster.png")#�Ώ�
        @weapon_message2.image("./image/weapon_30/item_#{i}.png")#����
        @weapon_state = i
        @SE_get_count = "ON"
        $get_SE.play if $BGM_state[0][0] == "ON"
        #����ɐG�ꂽ���ɔ�΂�����
        for j in 0..$weapon_number
          @weapon[j].x = @weapon_x[j]
          @weapon[j].y = @weapon_y[j]
        end
        @weapon[i].x += 1000
        @weapon[i].y += 1000
      end
    end
    
    #p $monster[i].x
    
    #�J�M�ƐڐG�������̏���
    for i in 0..$key_number
      if $player.x == @item[i].x && $player.y == @item[i].y && @SE_get_count == "OFF"
        $file.puts "�J�M�����Ƃ���,����,#{S_Timer.get}"
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
        
        
        #�J�M�ɐG�ꂽ���ɔ�΂�����
        for j in 0..$key_number
          @item[j].x = @item_x[j]
          @item[j].y = @item_y[j]
        end
        @item[i].x += 1000
        @item[i].y += 1000
      end
    end
    
    #�󔠂ɐڐG�������̏���
#=begin
#@treasure_player_posi_x = [30,0,30,30,0]
#@treasure_player_posi_y = [0,30,0,0,30]
#@trasure_direct = ["RIGHT","DOWN","RIGHT","RIGHT","DOWN"] #�󔠂̂ق��Ɍ����Ă��鎞�ɊJ��
p $BGM_state[0][0]
if Input.keyPush?(K_O) #O����͂����献���J��OPEN
for i in 0..$takarabako_number
    if @img[@treasurebox_posi_x[i]][@treasurebox_posi_y[i]].x == $player.x && @img[@treasurebox_posi_x[i]][@treasurebox_posi_y[i]].y == $player.y
      if $key_state == $key_teiji[1][i] && @open_count[i] == "OFF" #@takarabako_color[@r] ��������
        $feeling_bikkuri.x = $player.x
        $feeling_bikkuri.y = $player.y - 30
#=begin #�󔠂��J�������Ƃɂ��Ƃ�����
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
            @open_count[i] = "ON" #�����󔠂����J���Ȃ��悤�ɂ������
            p @gage_full_count += 1 #gage�𑝂₷����������
            for i in 1..@gage_full_count
              @clear_gage_img[i].image("./image/clear_gage/gage_full_30.png") #�������炾�߂�����t���ɂȂ����Ƃ���ŃQ�[���N���A�ɂ���
            end
          end
        end
        $file.puts "�N���A,����,#{S_Timer.get},�J�����J�M,#{@open_key}" if $feeling_bikkuri_count == "OFF"
        $feeling_bikkuri_count = "ON"
        #@game_clear_count = "ON"
        #clear_update
        
      elsif $key_state != $key_teiji[1][i] #&& @open_count[i] == "OFF" #�Ԉ������
        $file.puts "�ԈႢ,,#{S_Timer.get},�ԈႦ���J�M,#{@open_key}" if $feeling_mugon_count == "OFF"
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
end #�J�M���J���{�^���̓���

    if @gage_full_count == @clear_gage_count
      p 9999
      @game_clear_count = "ON"
      clear_update
    end
#=end

    #�󔠂ɐڐG�������̏���
=begin
    if @img[@height-1][@height-1].x == $player.x && @img[@height-1][@height-1].y == $player.y
      if $key_state == $key_teiji[1][@rand] #@takarabako_color[@r] ��������
        $feeling_bikkuri.x = $player.x
        $feeling_bikkuri.y = $player.y - 30
        if $feeling_bikkuri_count == "OFF"
          if $BGM_state[0][0] == "ON"
            $seikai_SE.play
          end
        end
        $file.puts "�N���A,����,#{S_Timer.get},�J�����J�M,#{@open_key}" if $feeling_bikkuri_count == "OFF"
        $feeling_bikkuri_count = "ON"
        @game_clear_count = "ON"
        clear_update
      elsif $key_state != $key_teiji[1][@rand] #�Ԉ������
        $file.puts "�ԈႢ,,#{S_Timer.get},�ԈႦ���J�M,#{@open_key}" if $feeling_mugon_count == "OFF"
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


    #����ɐڐG�������̏���
=begin
    for i in 0..$weapon_number
      if @weapon[i].x == $player.x && @weapon[i].y == $player.y
        @weapon_window.image("./image/weapon_90/item_#{i}.png")
        #$get_SE.play
    end
=end
    
#=begin
    
    
    
    
#�i�񂾎��̔���

#��ɐi�񂾂Ƃ� �ǐՂ���G
#�_���[�W�̃t���O
    #$monster_damage_flag = "OFF"
    #$player_damage_count = 0
#=begin �o�O�̌�
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
    
    
    
#########################################�ȉ��ɍU���̏����������Ă���
#=begin
#��ɐi�񂾂Ƃ� �ǐՂ���G
#=begin
    if Input.keyPush?(K_SPACE) && @weapon_state != nil && @player_direct == "UP"
      p 88 #�����܂ł͓���
      $feeling_bikkuri_count = "OFF"
      $feeling_mugon_count = "OFF"
      for i in 1..$trace_monster_number
        if $player.x == $monster[i].x && $player.y == $monster[i].y + 30
          p 77777777
          $maze["#{($monster[i].y-$masu_posi[1])/30}".to_i]["#{($monster[i].x-$masu_posi[0])/30}".to_i] = 0
          $trace_monster_state[i] = "DEAD" #�L�����N�^�[�̐���
          $file.puts "��ɂ���G��|����,,#{S_Timer.get}"
          $player_damage_effect.x = $monster[i].x
          $player_damage_effect.y = $monster[i].y
          $player_damage_flag = "ON"
          $player_SE.play if $BGM_state[0][0] == "ON"
          $monster[i].y = 1280
          $monster[i].x = 1280
          #$player_damage_effect.x = $player.x
          #$player_damage_effect.y =$player.y - 30
          $player = Array_Images.new($player.x, $player.y,"./image/character/player.png",3,4,9)
          #����Ɋւ���Ƃ��끫
          @weapon_window.image("./image/weapon_90/item_window2.png") #����̏����̃C���[�W
          @weapon_state = nil #����̏������
          for j in 0..$weapon_number #����̏ꏊ�����ɖ߂�
            @weapon[j].x = @weapon_x[j]
            @weapon[j].y = @weapon_y[j]
          end
          #����Ɋւ���Ƃ��끪
        end
      end
    end
#=end
    

#���ɐi�񂾂Ƃ� �ǐՂ���G
#=begin
    if Input.keyPush?(K_SPACE) && @weapon_state != nil && @player_direct == "DOWN"
      p 88
      $feeling_bikkuri_count = "OFF"
      $feeling_mugon_count = "OFF"
      #�ǐՂ���G�ɐڐG�������̏��� 
      for i in 1..$trace_monster_number
        if $player.x == $monster[i].x && $player.y == $monster[i].y - 30
          p 77777777
          $maze["#{($monster[i].y-$masu_posi[1])/30}".to_i]["#{($monster[i].x-$masu_posi[0])/30}".to_i] = 0 #�����Ń����X�^�[�̂���ʒu���O�ɂȂ�
          $trace_monster_state[i] = "DEAD" #�L�����N�^�[�̐���
          $file.puts "���ɂ���G��|����,,#{S_Timer.get}"
          $player_damage_effect.x = $monster[i].x
          $player_damage_effect.y = $monster[i].y
          $player_damage_flag = "ON"
          $player_SE.play if $BGM_state[0][0] == "ON"
          $monster[i].y = 1280
          $monster[i].x = 1280
          #$player_damage_effect.x = $player.x
          #$player_damage_effect.y =$player.y - 30
          $player = Array_Images.new($player.x, $player.y,"./image/character/player.png",3,4,0)
          #����Ɋւ���Ƃ��끫
          @weapon_window.image("./image/weapon_90/item_window2.png") #����̏����̃C���[�W
          @weapon_state = nil #����̏������
          for j in 0..$weapon_number #����̏ꏊ�����ɖ߂�
            @weapon[j].x = @weapon_x[j]
            @weapon[j].y = @weapon_y[j]
          end
          #����Ɋւ���Ƃ��끪
        end
      end
    end
#=end

#�E�ɐi�񂾂Ƃ� �ǐՂ���G
#=begin
    if Input.keyPush?(K_SPACE) && @weapon_state != nil && @player_direct == "RIGHT"
      p 88
      $feeling_bikkuri_count = "OFF"
      $feeling_mugon_count = "OFF"
      #�ǐՂ���G�ɐڐG�������̏��� 
      for i in 1..$trace_monster_number
        if $player.y == $monster[i].y && $player.x == $monster[i].x - 30
          p 77777777
          $maze["#{($monster[i].y-$masu_posi[1])/30}".to_i]["#{($monster[i].x-$masu_posi[0])/30}".to_i] = 0
          $trace_monster_state[i] = "DEAD" #�L�����N�^�[�̐���
          $file.puts "�E�ɂ���G��|����,,#{S_Timer.get}"
          $player_damage_effect.x = $monster[i].x
          $player_damage_effect.y = $monster[i].y
          $player_damage_flag = "ON"
          $player_SE.play if $BGM_state[0][0] == "ON"
          $monster[i].y = 1280
          $monster[i].x = 1280
          #$player_damage_effect.x = $player.x
          #$player_damage_effect.y =$player.y - 30
          $player = Array_Images.new($player.x, $player.y,"./image/character/player.png",3,4,6)
          #����Ɋւ���Ƃ��끫
          @weapon_window.image("./image/weapon_90/item_window2.png") #����̏����̃C���[�W
          @weapon_state = nil #����̏������
          for j in 0..$weapon_number #����̏ꏊ�����ɖ߂�
            @weapon[j].x = @weapon_x[j]
            @weapon[j].y = @weapon_y[j]
          end
          #����Ɋւ���Ƃ��끪
        end
      end
    end
#=end

#���ɐi�񂾂Ƃ� �ǐՂ���G
#=begin
    if Input.keyPush?(K_SPACE) && @weapon_state != nil && @player_direct == "LEFT"
      p 88
      $feeling_bikkuri_count = "OFF"
      $feeling_mugon_count = "OFF"
      #�ǐՂ���G�ɐڐG�������̏��� 
      for i in 1..$trace_monster_number
        if $player.y == $monster[i].y && $player.x == $monster[i].x + 30
          p 77777777
          $maze["#{($monster[i].y-$masu_posi[1])/30}".to_i]["#{($monster[i].x-$masu_posi[0])/30}".to_i] = 0
          $trace_monster_state[i] = "DEAD" #�L�����N�^�[�̐���
          $file.puts "���ɂ���G��|����,,#{S_Timer.get}"
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
          #����Ɋւ���Ƃ��끫
          @weapon_window.image("./image/weapon_90/item_window2.png") #����̏����̃C���[�W
          @weapon_state = nil #����̏������
          for j in 0..$weapon_number #����̏ꏊ�����ɖ߂�
            @weapon[j].x = @weapon_x[j]
            @weapon[j].y = @weapon_y[j]
          end
          #����Ɋւ���Ƃ��끪
        end
      end
    end
#=end
#########################################�G�̕����̏�����
    for i in 1..$trace_monster_number
      if $trace_monster_state[i] == "DEAD" #�L�����N�^�[�̐���
        $trace_monster_alive_count[i] += 1 #�L�����N�^�[�̕����̃J�E���g
      end
      
      if $trace_monster_alive_count[i] >= $trace_monster_alive_limit
        #�v���C���[�̂���Ƃ���ł͕������Ȃ��悤�ɂ���
        $monster[i].x = $monster_posi_x[i]+$masu_posi[0]
        $monster[i].y = $monster_posi_y[i]+$masu_posi[1]
        $trace_monster_state[i] = "ALIVE"
        $trace_monster_alive_count[i] = 0
      end
    #$trace_monster_alive_count[i] = 0 #�L�����N�^�[�̕����̃J�E���g
    #$trace_monster_alive_limit = 100 #�����X�^�[���|����Ă��炱�̎��Ԃ��ĂΕ���
    end
#########################################�G�̕����̏�����
    #�����_���ɓ����G
    for i in $trace_monster_number..$random_monster_number #�����̂Ƃ���ȒP�ɂ��� �����_���ɓ����G�ɏՓ˂�����
      if $player.x == $monster2[i+1].x && $player.y == $monster2[i+1] .y
        @key_get.image("./image/item_window2.png")
      end
    end
=begin
    #�G�ɐڐG�������̏���
    for i in 1..$trace_monster_number
      if $player.x == $monster[i].x && $player.y == $monster[i].y
        p 99999
      end
    end
=end
    
  end #update
  
  def hit_render
    if @key_on_count == 1 #�J�M�̏��
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
    
##########################���g�̗̑�
    @heart_message.render
    for i in 1..$heart_number
      @heart_img[i].render
    end
##########################�Q�[���N���A�܂ł̃J�E���g
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
