#!ruby -Ks
#exerb�Ōł߂�exe����N������Ƃ��J�����g�f�B���N�g����exe�̃p�X�ɂ���l�I
if defined?(ExerbRuntime)
  Dir.chdir(File.dirname(ExerbRuntime.filepath))
end
##################################################################################################################################################################
require 'dxruby'
require './lib/source/button.rb'
require './lib/source/color.rb'
require './lib/source/font.rb'
require './lib/source/image.rb'
require './lib/source/scene1.rb'
require './lib/source/show.rb'
require './lib/source/window.rb'
require './lib/source/maze.rb'
require './lib/source/setting.rb'
require './lib/source/item/item.rb'
require './lib/source/item_zukan.rb'
require './lib/source/stage_select.rb'
require './lib/source/character/player.rb'
require './lib/source/character/trace_monster6.rb'
require './lib/source/character/random_monster2.rb'
require './lib/source/item.rb'
require './lib/source/maze.rb'
require './lib/source/hit.rb'
require './anime.rb'
require './Bass.rb'
require './lib/source/weighted_randomizer'
Bass.init(Window.hWnd)
##################################################################################################################################################################
Title          =""
Window.caption = Title
################  �{�^���Ɋւ���R�}���h  ################
#�{�^�����쐬����           @btn = Button.new(x, y, w, h, string, font_size, color, st_color, gr_color1, gr_color2)
#�{�^���̕�����ύX����     @btn.string=("����")
#�{�^���̐F��ύX����       @btn.color=(�F)
#�{�^���ɉ摜��\��t����   @btn.image=("�t�@�C���̃p�X")
#�{�^����\������           @btn.render
#�{�^���̍��W�ύX           @btn.set_pos(x���W, y���W)
#�{�^������������c         if @btn.pushed?
#�{�^�����h���b�O������c   if @btn.pushedDrag?
################  �摜�Ɋւ���R�}���h  ################
#�l�p�`���쐬����           @img = Images.new(x, y, w, h, string, font_size, color, st_color)
#������\������             @img.string=("����",�t�H���g�T�C�Y)
#�摜��\��t����           @img.image("�t�@�C���̖��O")
#�g�̍쐬                   @img.waku(�F)
################  �t�H���g�Ɋւ���R�}���h  ################
#                           @font = Fonts.new(0, 0, "", font_size, st_color)
################  ���̑��֗��ȃR�}���h  ################
#�V�[����ύX����           self.next_scene = Main_Scene�i���ړ���̃N���X���j
#�t�@�C����z��Ɋi�[����   @file = load_datafile("�t�@�C���̖��O")
#�^�C�}�[�����Z�b�g����     S_Timer.reset
#�^�C�}�[�̎��Ԃ��擾����   S_Timer.get
#�ꊇ�R�����g�A�E�g
=begin
�������R�����g�A�E�g�����
=end

#**�~�����@�\���������玩���ō���Ă݂悤�I**
##################################################################################################################################################################
#log�f�B���N�g�����Ȃ���΍쐬
#=begin
def logfolder_create
  $date   = Time.now.strftime("%Y.%m.%d_%H.%M.%S")
  $s_date = Time.now.strftime("%Y.%m.%d")
  if FileTest.exist?("log") == false
    Dir::mkdir("log")
  end
  if FileTest.exist?("log/#{$s_date}") == false
    Dir::mkdir("log/#{$s_date}")
  end
end
def logfile_open(string)
  fname   = "log/#{$s_date}/#{string}_#{$date}.csv"
  $file   = File::open(fname, "w")
end
logfolder_create
logfile_open("#{Title}")
#=end

#�X�N���[���V���b�g
#=begin
  def screen_shot
    Window.getScreenShot("./log/#{$s_date}/#{Time.now.strftime("%H.%M.%S")}.png")
    #$file.puts "ScreenShot,,,,#{S_Timer.get}"
  end
#=end
##################################################################################################################################################################
#���y�Ɋւ�Ƃ���
$seikai_SE  = Sound.new("./lib/sound/seikai.wav")
$select_SE = Sound.new("./lib/sound/select.wav")
$ok_SE = Sound.new("./lib/sound/ok.wav")
$cancel_SE = Sound.new("./lib/sound/cancel.wav")
BGM_forest = "./sound/field_BGM/forest_BGM.mp3"
BGM_cave = "./sound/field_BGM/cave_BGM.mp3"
BGM_desert = "./sound/field_BGM/desert_BGM.mp3"
BGM_ice = "./sound/field_BGM/ice_BGM.mp3"
BGM_swamp = "./sound/field_BGM/swamp_BGM.mp3"
BGM_snow = "./sound/field_BGM/snow_BGM.mp3"
BGM_volcano = "./sound/field_BGM/volcano_BGM.mp3"
BGM_eureka = "./sound/field_BGM/eureka_BGM.mp3"
BGM_grassland = "./sound/field_BGM/grassland_BGM.mp3"
BGM_sea = "./sound/field_BGM/sea_BGM.mp3"
BGM_castle = "./sound/field_BGM/castle_BGM.mp3"
BGM_machine = "./sound/field_BGM/machine_BGM.mp3"
BGM_clear = "./lib/sound/clear.mp3"
BGM_gameover = "./lib/sound/gameover.mp3"
BGM_title = "./lib/sound/title.mp3"
BGM_stage_select = "./lib/sound/stage_select.mp3"
BGM_rare_item = "./lib/sound/rare_item.mp3"
=begin
BGM_Main = "./lib/sound/bgm_main.mp3"
BGM_Gauge = "./lib/sound/bgm_gauge.mp3"
BGM_Pay = "./lib/sound/bgm_pay.mp3"
BGM_End = "./lib/sound/bgm_end.mp3"
=end
##################################################################################################################################################################
class Title_Scene < Init_Scene
  def init
    #@@bgm1 = Bass.loadSample(BGM_Title)
    #@@bgm1.play(:loop => true, :volume => 0.3)
    title_init    #�����̒��g��scene.rb�Q��
    #$trace_monster_number = 1
    $random_monster_number = 0
    #self.next_scene = Main_Scene4
    $BGM_state = load_datafile("./lib/data/BGM_state.txt") #[0][0]�ɂ��Ȃ��Ƃ����Ȃ�
    $bgm_title = Bass.loadSample(BGM_title)
    $bgm_title.play(:loop => true, :volume => 0.1) if $BGM_state[0][0] == "ON"
    $BGM_state = load_datafile("./lib/data/BGM_state.txt") #[0][0]�ɂ��Ȃ��Ƃ����Ȃ�
    @life_number = load_datafile("./lib/data/life_number.txt")
    $heart_number = @life_number[0][0].to_i
    $trace_monster_number = load_datafile("./lib/data/monster_data.txt")
    $trace_monster_number = $trace_monster_number[0][0].to_i
  end
  
  def update
    title_update  #�����̒��g��scene.rb�Q��
    if Input.keyPush?(K_R)
        p 110
      for i in 1..5
        file = File.open("./lib/data/item/item_data#{i}.txt","w+")
        file.puts("OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,")
        file.close
      end
    end
    
#=begin
    if Input.keyPush?(K_C)
      for i in 1..5
        p 119
        #file = File.open("./lib/data/item/item_data#{i}.txt","w+")
        #file.puts("ON,ON,ON,ON,ON,ON,ON,ON,")
        #file.close
      end
    end
#=end
  end
  
  def render
    title_render  #�����̒��g��scene.rb�Q��
  end

end

##################################################################################################################################################################
class Setting_Scene < Init_Scene
  def init
    setting_init
  end #init
  
  def update
    setting_update
  end #update
  
  def render
    setting_render
  end #render
end#Setting_Scene
###################################################################################################################################################################
class Item_Scene < Init_Scene
  def init
    item_zukan_init
    p $heart_number
  end #init
  
  def update
    item_zukan_update
  end #update
  
  def render
    item_zukan_render
  end #render
end#Setting_Scene
###################################################################################################################################################################
class Stageselect_Scene < Init_Scene
  def init
    @bgm_stage_select = Bass.loadSample(BGM_stage_select)
    @bgm_stage_select.play(:loop => true, :volume => 0.1) if $BGM_state[0][0] == "ON"
    stage_select_init
  end
  
  def update
    stage_select_update
  end #update
  
  def render
    stage_select_render
  end #render
end

###################################################################################################################################################################

class Show_Scene < Init_Scene
  def init
    p 8942146
    p $trace_monster_number
    show_init
  end #init
  
  def update
    show_update
    if Input.keyPush?(K_SPACE)
      self.next_scene = Main_Scene
    end
  end #update
  
  def render
    show_render
  end #render
end
###################################################################################################################################################################

class Main_Scene < Init_Scene #���ۂ̃Q�[���V�[��
  def init
    p 8942146
    p $trace_monster_number
    @bgm_clear = Bass.loadSample(BGM_clear)
    @bgm_gameover = Bass.loadSample(BGM_gameover)
    @game_clear_count = "OFF"
    $bgm_stage.play(:loop => true, :volume => 0.1) if $BGM_state[0][0] == "ON"
    $takarabako_teiji.shuffle #�󔠂������
    $player_move_stop = "OFF" #�����������Ƃ��ɃL�����̓������~�߂����
    p $takarabako_teiji
    player_init
##################################�L�����N�^�[�������[�u
    @anime_count = 0
    @anime_limit = 30
##################################�}�X�̍��W��T�C�Y�ύX
    #�}�X�̏ꏊ�̒���
    $masu_posi = [80,80] #�������W
    #$masu_size = [30,40,50] #�}�X�̃T�C�Y��ύX��
##################################
    maze_init #���H�̍s���~�܂������Ȃ��[�u
    $player = Array_Images.new(30+$masu_posi[0], 30+$masu_posi[1],"./image/character/player.png",3,4,0)
#�ǂ������郂���X�^�[
    $monster = Array.new
    $monster_posi_x =[0,510,30,510,270,270,30,270,510]
    $monster_posi_y =[0,30,510,510,270,30,270,510,270]
    for i in 1..$trace_monster_number 
      $monster[i] = Array_Images.new($monster_posi_x[i]+$masu_posi[0], $monster_posi_y[i]+$masu_posi[1],"./image/character/monster1.png",3,4,0)
    end
    #�����_���ȓ��������郂���X�^�[
    trace_monster_init
    random_monster_init
    @btn = Button.new(900, 700, 50, 50, "#{$trace_monster_number}", 24, White, Black)
    @btn2 = Button.new(950, 700, 50, 50, "#{$random_monster_number}", 24, Red, Black)
    @back_btn = Button.new(Window_w-100, 0, 100, 50, "�߂�", 24, Gray, Black)
    $monster2 = Array.new
    $monster2_posi_x =[0,510,30,510,270,270,30,270,510]
    $monster2_posi_y =[0,30,510,510,270,30,270,510,270]
    for i in $trace_monster_number..$random_monster_number #�����̂Ƃ���ȒP�ɂ���
      $monster2[i+1] = Array_Images.new($monster2_posi_x[i+1]+$masu_posi[0], $monster2_posi_y[i+1]+$masu_posi[1],"./image/character/monster2.png",3,4,0)
    end
    $takarabako_color = "color" #Main_Scene2�ɂ킽���󔠂̏��
######################################�w�i
    @map_BG_img = Images.new(0,0,1,1)
    #$map = ["forest","cave","desert","ice","swamp","snow","volcano","darkness"]
    $map = ["forest","cave","grassland","desert","ice","sea","swamp","snow","castle","volcano","eureka","machine"]
    @map_BG_img.image("./image/#{$map[$map_count]}/BG_#{$map[$map_count]}.png")
######################################��
    $road = Array.new
    $road_count = 0
    for i in 0..@height
      for j in 0..@width
        if $maze[i][j] == 0 #��
          @img[i][j].image("./image/#{$map[$map_count]}/mapchip0.png")
          $road_count += 1
          $road[$road_count] = [i,j]
        elsif $maze[i][j] == 1 #��
          @img[i][j].image("./image/#{$map[$map_count]}/mapchip1.png")
        end
      end
    end
######################################�ӂ�h��Ԃ�
    @img2 = Array.new
    @img3 = Array.new
    for i in 0..@height
      @img3[i]  = Images.new(i*30+$masu_posi[0], $masu_posi[1], 30, 30, "", 24, Gray, Black)
      @img3[i].image("./image/#{$map[$map_count]}/wall3.png")
    end
    
    for i in 0..@height
      @img2[i] = Array_Images.new(i*30+$masu_posi[0], $masu_posi[1]-30,"./image/#{$map[$map_count]}/wall.png",1,5,2) #���
      @img2[i+@height] = Array_Images.new(i*30+$masu_posi[0], $masu_posi[1]+@height*30,"./image/#{$map[$map_count]}/wall.png",1,5,2) #����
      @img2[i+2*@height] = Array_Images.new($masu_posi[0], $masu_posi[1]-30+i*30,"./image/#{$map[$map_count]}/wall.png",1,5,1) #����
      @img2[i+3*@height] = Array_Images.new(@height*30+$masu_posi[0], $masu_posi[1]-30+i*30,"./image/#{$map[$map_count]}/wall.png",1,5,1) #�E��
    end
######################################�S����h��Ԃ�
    @img_right_up = Array_Images.new(@height*30+$masu_posi[0], $masu_posi[1]-30,"./image/#{$map[$map_count]}/wall.png",1,5,3) #�E��
    @img_right_down = Array_Images.new(@height*30+$masu_posi[0], $masu_posi[1]+@height*30,"./image/#{$map[$map_count]}/wall.png",1,5,3) #�E��
    @img_left_up = Array_Images.new($masu_posi[0], $masu_posi[1]-30,"./image/#{$map[$map_count]}/wall.png",1,5,3) #����
    @img_left_down = Array_Images.new($masu_posi[0], $masu_posi[1]+@height*30,"./image/#{$map[$map_count]}/wall.png",1,5,3) #����
############################�󔠂̔z�u
    @rand = rand($takarabako_number+1)
    #$monster_posi_x =[0,510,30,510,270,270,30,270,510]
    @treasurebox_posi_x = [19,19,1,10,19]
    @treasurebox_posi_y = [19,1,19,19,10]
    #@treasurebox_posi_x = [19,20,1,10,20]
    #@treasurebox_posi_y = [20,1,20,20,10]
    #@treasurebox_posi_x.shuffleooo 
    #@treasurebox_posi_y.shuffle �V���b�t������Ƒg�ݍ��킹���ς�邩��ǂ����悤��
    p $takarabako_number # + 1 #����Ȃ��{�P���邩�ǂ���
    #@img[@height-1][@height-1].color($takarabako_teiji[1][i]) #����ł��n�j
    #$takarabako_teiji = [["�Ԃ��󔠂�","���󔠂�","���F���󔠂�","�s���N�F�̕󔠂�","�ΐF�̕󔠂�"],[Red,Blue,Yellow,Pink,Green]]
    
for i in 0..$takarabako_number
    case $takarabako_teiji[1][i]
    when Red
      @img[@treasurebox_posi_x[i]][@treasurebox_posi_y[i]].image("./image/takarabako_30/takarabako_red.png")
      $takarabako_color = "red" #Main_Scene2�ɓn���󔠂̏��
    when Blue
      @img[@treasurebox_posi_x[i]][@treasurebox_posi_y[i]].image("./image/takarabako_30/takarabako_blue.png")
      $takarabako_color = "blue" #Main_Scene2�ɓn���󔠂̏��
    when Yellow
      @img[@treasurebox_posi_x[i]][@treasurebox_posi_y[i]].image("./image/takarabako_30/takarabako_yellow.png")
      $takarabako_color = "yellow" #Main_Scene2�ɓn���󔠂̏��
    when Pink
      @img[@treasurebox_posi_x[i]][@treasurebox_posi_y[i]].image("./image/takarabako_30/takarabako_purple.png")
      $takarabako_color = "purple" #Main_Scene2�ɓn���󔠂̏��
    when Green
      @img[@treasurebox_posi_x[i]][@treasurebox_posi_y[i]].image("./image/takarabako_30/takarabako_green.png")
      $takarabako_color = "green" #Main_Scene2�ɓn���󔠂̏��
    end
end

=begin
for i in 0..$takarabako_number
    @img[@height-1][@height-1].color($takarabako_teiji[1][0]) #����ł��n�j
    case $takarabako_teiji[1][@rand]
    when Red
      @img[@height-1][@height-1].image("./image/takarabako_30/takarabako_red.png")
      $takarabako_color = "red" #Main_Scene2�ɓn���󔠂̏��
    when Blue
      @img[@height-1][@height-1].image("./image/takarabako_30/takarabako_blue.png")
      $takarabako_color = "blue" #Main_Scene2�ɓn���󔠂̏��
    when Yellow
      @img[@height-1][@height-1].image("./image/takarabako_30/takarabako_yellow.png")
      $takarabako_color = "yellow" #Main_Scene2�ɓn���󔠂̏��
    when Pink
      @img[@height-1][@height-1].image("./image/takarabako_30/takarabako_purple.png")
      $takarabako_color = "purple" #Main_Scene2�ɓn���󔠂̏��
    when Green
      @img[@height-1][@height-1].image("./image/takarabako_30/takarabako_green.png")
      $takarabako_color = "green" #Main_Scene2�ɓn���󔠂̏��
    end
end
=end
############################�󔠂̔z�u
    #@img[@height-1][@height-19].color($takarabako_teiji[1][1]) #����ł��n�j ����
    #@img[@height-10][@height-1].color($takarabako_teiji[1][2]) #����ł��n�j �E��
    #@img[@height-1][@height-10].color($takarabako_teiji[1][3]) #����ł��n�j ����
    #@img[@height-19][@height-1].color($takarabako_teiji[1][4]) #����ł��n�j �E��
######################################
    item_init 
    hit_init
    item_init
    #@map_count = 10
    clear_init
    gameover_init
    #�����Ń��Z�b�g����
    $key_state = nil
    $file.puts "�󔠂̐�,#{$takarabako_number},�X�e�[�W�ԍ�,#{$stage_number},�E���̕�,#{$takarabako_color},�������J�M,,"
    S_Timer.reset
  end #init
  
  def clear_init
    @game_clear_img = Images.new(Window_w, 150, 700, 50, "", 40, Black, Black)
    @game_clear_img.image("./image/Main_Scene2/gameclear.png")
    @senter_posi_x = (Window_w - @game_clear_img.w)/2
    @senter_posi_y = (Window_h - @game_clear_img.h)/2
    @game_clear_img.y = @senter_posi_y
    @clear_count = 0
  end #init
  
  def gameover_init
    @game_over_img = Images.new(Window_w, 150, 700, 50, "", 40, Black, Black)
    @game_over_img.image("./image/Main_Scene2/gameover.png")
    @senter_posi_x = (Window_w - @game_over_img.w)/2
    @senter_posi_y = (Window_h - @game_over_img.h)/2
    @game_over_img.y = @senter_posi_y
    @game_over_count = 0
  end #init
  
  def update
###################���W��m�邽�߂̑[�u
    if Input.keyPush?(K_Q)#����
      $maze["#{($player.y-$masu_posi[1])/30}".to_i-1]["#{($player.x-$masu_posi[0])/30}".to_i] = 0
      $maze["#{($player.y-$masu_posi[1])/30}".to_i+1]["#{($player.x-$masu_posi[0])/30}".to_i] = 0
    end
    
    if Input.keyPush?(K_Z)#����
      p $player.x
      p $player.y
    end
    
    if Input.keyPush?(K_A)#����
      $maze["#{($player.y-$masu_posi[1])/30}".to_i]["#{($player.x-$masu_posi[0])/30}".to_i-1] = 0
      $maze["#{($player.y-$masu_posi[1])/30}".to_i]["#{($player.x-$masu_posi[0])/30}".to_i+1] = 0
    end
=begin
    if Input.keyPush?(K_W)#��
      p $maze["#{($player.y-$masu_posi[1])/30}".to_i-1]["#{($player.x-$masu_posi[0])/30}".to_i]
    end
    
    if Input.keyPush?(K_A)#��
      p $maze["#{($player.y-$masu_posi[1])/30}".to_i]["#{($player.x-$masu_posi[0])/30}".to_i-1]
    end
    
    if Input.keyPush?(K_D)#��
      p $maze["#{($player.y-$masu_posi[1])/30}".to_i]["#{($player.x-$masu_posi[0])/30}".to_i+1]
    end
    
    if Input.keyPush?(K_Z)#��
      p $maze["#{($player.y-$masu_posi[1])/30}".to_i+1]["#{($player.x-$masu_posi[0])/30}".to_i]
    end
=end
###################
    #p S_Timer.get
    #p $key_state
#=begin
    if Input.keyPush?(K_B)
      $bgm_stage.stop
      self.next_scene = Show_Scene
    end
    
    if Input.keyPush?(K_N)
      $bgm_stage.stop #�X�e�[�W�̂a�f�l���~�߂� �͋Z�����ǂ���Ŏ~�܂�
      self.next_scene = Main_Scene2
    end
    
    if Input.keyPush?(K_P)
      $bgm_stage.stop
    end
#=end
    
    if Input.keyPush?(K_M)
      $map_count += 1
      if $map_count == 3
        $map_count = 0
        self.next_scene = Main_Scene
      else
        self.next_scene = Main_Scene
      end
    end
    
    if @game_clear_count == "OFF" #�Q�[�����ŏI�I�ɃN���A�������ɂn�m�ɂ���
      player_update
      trace_monster_update
      random_monster_update
      if @back_btn.pushed?
        self.next_scene = Title_Scene
      end
    end #@game_clear_count��OFF�̎�
#=end
######################�Q�[�����N���A������
    hit_update
    if Input.keyDown?(K_T)
      clear_update
    end
    
    
    if Input.keyPush?(K_S)
      screen_shot
    end
    
    
    
    if $heart_number <= 0
      gameover_update
    end
  end #update
  
  def clear_update
    if @senter_posi_x <= @game_clear_img.x
      if @game_clear_img.x == 1019
        @bgm_clear.play(:loop => false, :volume => 0.1) if $BGM_state[0][0] == "ON"
        $bgm_stage.stop #�X�e�[�W�̂a�f�l���~�߂� �͋Z�����ǂ���Ŏ~�܂�
        #$bgm_stage
      end
      @game_clear_img.x -= 5
    elsif @senter_posi_x >= @game_clear_img.x
      @clear_count += 1
      if @clear_count >= 50
        @game_clear_img.x -= 5
        if @game_clear_img.x <= 0 - @game_clear_img.w
          @bgm_clear.stop
          self.next_scene = Main_Scene2
        end
      end
    end
  end #clear_update
  
  def gameover_update
    @game_clear_count = "ON"
    if @senter_posi_x <= @game_over_img.x
      if @game_over_img.x == 1019
        $file.puts "�Q�[���I�[�o�[,����,#{S_Timer.get}"
        @bgm_gameover.play(:loop => false, :volume => 0.1) if $BGM_state[0][0] == "ON"
        $bgm_stage.stop #�X�e�[�W�̂a�f�l���~�߂� �͋Z�����ǂ���Ŏ~�܂�
      end
      @game_over_img.x -= 5
    elsif @senter_posi_x >= @game_over_img.x
      @game_over_count += 1
      if @game_over_count >= 50
        @game_over_img.x -= 5
        if @game_over_img.x <= 0 - @game_over_img.w
          @bgm_gameover.stop
          self.next_scene = Title_Scene
        end
      end
    end
  end #gameover_update
  
  def render
    @map_BG_img.render
    
    for i in 0..@height
      for j in 0..@width
        @img[i][j].render
      end
    end
######################################�ӂ�h��Ԃ�
    for i in 0..@height
      @img3[i].render #��̕ǂ̓h��Ԃ�
    end
    
    for i in 0..4*@height
      @img2[i].render #�l�ӂ̓h��Ԃ�
    end
    
#####################################�󔠂̏������������悤�ɂ���
    for i in 0..0
      @img[@treasurebox_posi_x[i]][@treasurebox_posi_y[i]].render
    end
    
#####################################�S����h��Ԃ�
    @img_right_up.render
    @img_right_down.render
    @img_left_up.render
    @img_left_down.render
#####################################
    item_render
    $player.render
    hit_render
    for i in 1..$trace_monster_number
      $monster[i].render
    end
    
=begin
    for i in $trace_monster_number..$random_monster_number
      $monster2[i+1].render
    end
=end
    #���b�Z�[�W
    #@weapon_message.render
    #@weapon_message1.render
    #@weapon_message2.render
    @game_clear_img.render
    @game_over_img.render
  end #render
end

$SE  = Sound.new("./lib/sound/seikai.wav")

class Main_Scene2 < Init_Scene
  def init
    #�U���ɕK�v�Ȃ���
    @player_direct
    #�C���[�W
    @BG_img = Images.new(0,0,1,1)
    @BG_img.image("./image/Main_Scene2/bg.png")
    @frame_img = Images.new(0,0,1,1) #�t���[��
    @frame_img.image("./image/Main_Scene2/frame001a.png")
    @message_img = Images.new(50,70, 500, 50, "�Ăɂ��ꂽ������΂��������ɂ񂵂悤", 40, Cream,White) #���b�Z�[�W
    @message_img.image("./image/frame/frame.png")
    @message_img.font_color(White)
    @img_count = 2
    @takarabako_img = Array_Images.new((Window_w/2) - 100, 400,"./image/Main_Scene2/takarabako_#{$takarabako_color}/takarabako_#{$takarabako_color}1.png",1,1,0)
    #@takarabako_img = Images.new(Window_w/2 - 100, 400, 200, 200, "", 24, White, Black) #�l��������
    #@takarabako_img.image("./image/Main_Scene2/takarabako_red.png")
    #�{�^��
    @btn = Button.new(Window_w/2 - 200, 200, 400, 100, "", 24, White, White)
    @btn.image("./image/Main_Scene2/push_button.png")
    Anime_Timer.reset
    @anime_moving = "OFF"
    #@effect_img = Array_Images.new(0, 0,"./image/Main_Scene2/pipo-btleffect148c.png",1,10,0)
    #log�Ɋւ��鏊
  end
  
  def update
    if Input.keyPush?(K_T)
      self.next_scene = Show_Scene
    end
    
    if @btn.pushed? || Input.mousePush?(M_LBUTTON)
      @anime_moving = "ON"
      #@effect_img.n += 1
    end
    
    if Input.keyPush?(K_SPACE)
      @anime_moving = "ON"
    end
    
    if @anime_moving == "ON"
      if @img_count != 6
        if Anime_Timer.get >= 0.3
          @takarabako_img = Array_Images.new((Window_w/2) - 100, 400,"./image/Main_Scene2/takarabako_#{$takarabako_color}/takarabako_#{$takarabako_color}#{@img_count}.png",1,1,0)
          @img_count += 1
          Anime_Timer.reset 
        end
      elsif @img_count >= 6  #&& @img_count <= 6
        #������`
        self.next_scene = Main_Scene3
      end
    end
    p @player_direct
  end #update
  
  def render
    @takarabako_img.render
    @BG_img.render
    @frame_img.render
    @message_img.render
    @takarabako_img.render
    @btn.render
=begin
    if @anime_moving == "ON"
      if @img_count >= 6  #&& @img_count <= 6
        @windbeam.draw
      end
    end
=end
    #@effect_img.render
  end
end

class Main_Scene3 < Init_Scene
  def init
    @windbeam = Wind_beam.new(0,0)
    @encount = Wind_beam.new(0,0)
  end
  
  def update
    @windbeam.update
    if Input.mousePush?(M_LBUTTON)
      self.next_scene = Main_Scene4
    end
    
    if Input.keyPush?(K_N)
      self.next_scene = Main_Scene4
    end
    
    if Input.keyPush?(K_SPACE)
      self.next_scene = Main_Scene4
    end
  end
  
  def render
    @windbeam.draw
  end
end

class Main_Scene4 < Init_Scene
  def init
    @yellowflash2 = Yellow_flash2.new(0,0)
    @encount = Wind_beam.new(0,0)
    @congratulations = Images.new(120, 50, 900, 200, "", 40, Cream, Black) #�g�ݍ��킹�̃��b�Z�[�W
    @congratulations.image("./image/Main_Scene2/congratulations.png")
    @back_btn = Button.new(Window_w - 72, 0, 72, 36, "�I��", 16, Dgray, White)
###############################�f�[�^���n�m�ɂ���Ƃ���̏���
    @a = Array.new
    $card_weight1 = WeightedRandomizer.new('rank_1' => 50, 'rank_2' => 40, 'rank_3' => 30, 'rank_4' => 20, 'rank_5' => 10)#�J�[�h�̔r�o����
#=begin
    case "#{$card_weight1.sample}"
    when "rank_1"
      p "rank_1"
      p @r1 = rand(14)+1 #�����N�̃A�C�e���ԍ�
      p @r2 = @r1/9 + 1 #�y�[�W�ԍ�
      p @r3 = (@r1-1)%8 #txt�̂ǂ����n�m�ɂ��邩
    when "rank_2"
      p "rank_2"
      p @r1 = rand(9)+15 #�����N�̃A�C�e���ԍ�
      p @r2 = @r1/17 + 2 #�y�[�W�ԍ�
      p @r3 = (@r1-1)%8 #txt�̂ǂ����n�m�ɂ��邩
    when "rank_3"
      p "rank_3"
      p @r1 = rand(8)+24 #�����N�̃A�C�e���ԍ�
      p @r2 = @r1/25 + 3 #�y�[�W�ԍ�
      p @r3 = (@r1-1)%8 #txt�̂ǂ����n�m�ɂ��邩
    when "rank_4"
      p "rank_4"
      p @r1 = rand(5)+32 #�����N�̃A�C�e���ԍ�
      p @r2 = @r1/33 + 4 #�y�[�W�ԍ�
      p @r3 = (@r1-1)%8 #txt�̂ǂ����n�m�ɂ��邩
    when "rank_5"
      p "rank_5"
      p @r1 = rand(4)+37 #�����N�̃A�C�e���ԍ�
      p @r2 = @r1/41 + 5 #�y�[�W�ԍ�
      p @r3 = (@r1-1)%8 #txt�̂ǂ����n�m�ɂ��邩
    end
#=end
    
#=begin
    @file = load_datafile("./lib/data/item/item_data#{@r2}.txt") #[0][0]�ɂ��Ȃ��Ƃ����Ȃ�
    @a[@r3] = "ON"
    file = File.open("./lib/data/item/item_data#{@r2}.txt","w+")
    for i in 0..7
      if @a[i] == "ON"
        file.printf("#{@a[i]},")
      elsif @a[i] == nil
        file.printf("#{@file[0][i]},")
      end
    end
    file.close
#=end
###############################
#=begin
    @item_name = Array.new
    @item_name = load_datafile("./lib/data/message/message_data#{@r2}.txt") #[0][0]�ɂ��Ȃ��Ƃ����Ȃ�
    @message_img = Images.new(50, 500, 500, 50, "#{@item_name[@r3][0]}", 40, Cream, Black) #�g�ݍ��킹�̃��b�Z�[�W
    @message_img.image("./image/frame/frame3.png")
    @message_img.font_color(White)
    @item_img = Images.new(400, 250, 200, 200, "", 40, Black, Black) #�A�C�e���̃C���[�W
    @item_img.image("./lib/item/item/#{@r1}.png")
#=end
###############################
    #file.close
  end #init
  
  def update
    @yellowflash2.update
    if Input.keyPush?(K_T)
      self.next_scene = Main_Scene4
    end
    
    if @back_btn.pushed?
      self.next_scene = Title_Scene
    end
    
    if Input.keyPush?(K_SPACE)
      self.next_scene = Title_Scene
    end
  end #update
  
  def render
    @yellowflash2.draw
    @message_img.render
    @congratulations.render
    @item_img.render
    if Input.keyPush?(K_T)
      self.next_scene = Main_Scene4
    end
    @back_btn.render
  end #render
end
##################################################################################################################################################################
Scene.main_loop(Title_Scene)
