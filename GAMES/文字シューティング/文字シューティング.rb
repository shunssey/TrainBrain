#!ruby -Ks
#exerb�Ōł߂�exe����N������Ƃ��J�����g�f�B���N�g����exe�̃p�X�ɂ���
if defined?(ExerbRuntime)
  Dir.chdir(File.dirname(ExerbRuntime.filepath))
end
######################################################
require 'dxruby'
require 'lib/scene.rb'
require 'lib/button.rb'
require 'lib/font.rb'
require 'lib/sub_class.rb'
require "lib/checkbox_for_dxruby"
######################################################
Black = [0, 0, 0]
White = [255, 255, 255]
Green = [0, 255, 0]
Blue = [0, 0, 255]
Red = [255, 0, 0]
Orange = [255, 255, 0]
Gray = [110, 110, 110]
######################################################
Window_w = 1024
Window_h = 768
Window.width  = Window_w
Window.height = Window_h
Window.bgcolor = White
Window.caption = "�V���[�e�B���O"
Window.fps = 60
FPS = 60
######################################################
#log�f�B���N�g�����Ȃ���΍쐬
if FileTest.exist?("log") == false
  Dir::mkdir("log")
end
######log########################################
def logfile_open(string)
  date = Time.now.strftime("%Y.%m.%d_%H.%M.%S")
  fname = "log/#{string}_#{date}.csv"
  $file = File::open(fname, "w")
  $file.puts "���̐�,�񎦕��@,�����̎��,���C�P��,�V�[��,�ˌ��I,����,����"
end
logfile_open("�V���[�e�B���O") 

def logfile_point_open(string)
  date = Time.now.strftime("%Y.%m.%d_%H.%M.%S")
  fname = "log_point/#{string}_#{date}.csv"
  $file_point = File::open(fname, "w")
  $file_point.puts "����,�}�E�Xx,�}�E�Xy,���D0,���D0x,���D0y,���D1,���D1x,���D1y,���D2,���D2x,���D2y,���D3,���D3x,���D3y,���D4,���D4x,���D4y,"
end
#######################################################
class S_Timer
  def self.reset  #���Ԃ�������
    @start_time = Time.now
  end

  def self.get  #�o�ߎ��Ԃ𓾂�
    return Time.now - @start_time
  end
end

####################################################################################################
#�Q�[���S�̂ň����O���[�o���ϐ����`
#$count = 0        # �Q�[���̉�
#$score = 100        # �_��
$flag_oto = 0     # 0:�P��, 1:2���ȏ�
$flag_teiji = 0   # 0:���o��, 1:���o��
$flag_moji = 0    # 0:�Ђ炪��, 1:�J�^�J�i, 2:�A���t�@�x�b�g��, 3:�A���t�@�x�b�g��
$flag_mode = 0    # 0:����, 1:�t��, 2:�폜, 3:���o
####################################################################################################
class Setup_Scene < Scene::Base
  def init
    @btn_full = Button.new(Window_w-72*2, 0, "full/win", 16,72,36)
    @btn_esc = Button.new(Window_w-72, 0, "�I��", 16,72,36)
    @btn_start = Button.new(800, 650, "����", 32,144,72)
    @image = Image.load("image/Setup_bg.png", 0, 0, 1024, 768)
    
    ##�Q�[���S�̂ň����O���[�o���ϐ����`
    #$count = 0        # �Q�[���̉�
    #$score = 100        # �_��
    #$flag_oto = 0     # 0:�P��, 1:2���ȏ�
    #$flag_teiji = 0   # 0:���o��, 1:���o��
    #$flag_moji = 0    # 0:�Ђ炪��, 1:�J�^�J�i, 2:�A���t�@�x�b�g��, 3:�A���t�@�x�b�g��
    #$flag_mode = 0    # 0:����, 1:�t��, 2:�폜, 3:���o
    
    Input.mouseEnable=true #���}�E�X�J�[�\����\��
    check_init
  end
  
  def update
    if @btn_full.pushed?
      if Window.windowed?
        Window.windowed = false
      else
        Window.windowed = true
      end
    elsif @btn_esc.pushed?
      exit
    end
    
    self.next_scene = Title_Scene if @btn_start.pushed?
    
    check_update
  end
  
  def render
    Window.draw(0,0,@image)
    @btn_full.render
    @btn_esc.render
    @btn_start.render
    
    check_render
  end
  
  #--------------------------------------------------------
  
  def check_init
    check_x, check_y = 300, 125
    
    #���̐�
    @check_oto = Array.new()
    @check_oto[0] = Checkbox.new(check_x, check_y,"�P��")
    @check_oto[1] = Checkbox.new(check_x+200, check_y,"2���ȏ�")
    @check_oto[$flag_oto].set
    
    #�񎦕��@
    @check_teiji = Array.new()
    @check_teiji[0] = Checkbox.new(check_x, check_y+95,"���o��")
    @check_teiji[1] = Checkbox.new(check_x+200, check_y+95,"���o��")
    @check_teiji[$flag_teiji].set
    
    #�����̎��
    @check_moji = Array.new()
    @check_moji[0] = Checkbox.new(check_x, check_y+185,"�Ђ炪��")
    @check_moji[1] = Checkbox.new(check_x+300, check_y+185,"�J�^�J�i")
    @check_moji[2] = Checkbox.new(check_x, check_y+255,"�A���t�@�x�b�g(��)")
    @check_moji[3] = Checkbox.new(check_x+300, check_y+255,"�A���t�@�x�b�g(��)")
    @check_moji[$flag_moji].set
    
    #���C�P�����[�h
    @check_mode = Array.new()
    @check_mode[0] = Checkbox.new(check_x, check_y+335,"����")
    @check_mode[1] = Checkbox.new(check_x+300, check_y+335,"�t��")
    @check_mode[2] = Checkbox.new(check_x, check_y+405,"�폜")
    @check_mode[3] = Checkbox.new(check_x+300, check_y+405,"���o")
    @check_mode[$flag_mode].set
  end
  
  def check_update
    #���̐�
    if @check_oto[0].clicked?
      @check_oto[1].reset
      $flag_oto = 0
    elsif @check_oto[1].clicked?
      @check_oto[0].reset
      $flag_oto = 1
    end
    
    #�񎦕��@
    if @check_teiji[0].clicked?
      @check_teiji[1].reset
      $flag_teiji = 0
    elsif @check_teiji[1].clicked?
      @check_teiji[0].reset
      $flag_teiji = 1
    end
    
    #�����̎��
    if @check_moji[0].clicked?
      @check_moji[1].reset
      @check_moji[2].reset
      @check_moji[3].reset
      $flag_moji = 0
    elsif @check_moji[1].clicked?
      @check_moji[0].reset
      @check_moji[2].reset
      @check_moji[3].reset
      $flag_moji = 1
    elsif @check_moji[2].clicked?
      @check_moji[0].reset
      @check_moji[1].reset
      @check_moji[3].reset
      $flag_moji = 2
    elsif @check_moji[3].clicked?
      @check_moji[0].reset
      @check_moji[1].reset
      @check_moji[2].reset
      $flag_moji = 3
    end
    
    #���C�P�����[�h
    if $flag_oto == 1
      if @check_mode[0].clicked?
        @check_mode[1].reset
        @check_mode[2].reset
        @check_mode[3].reset
        $flag_mode = 0
      elsif @check_mode[1].clicked?
        @check_mode[0].reset
        @check_mode[2].reset
        @check_mode[3].reset
        $flag_mode = 1
      elsif @check_mode[2].clicked?
        @check_mode[0].reset
        @check_mode[1].reset
        @check_mode[3].reset
        $flag_mode = 2
      elsif @check_mode[3].clicked?
        @check_mode[0].reset
        @check_mode[1].reset
        @check_mode[2].reset
        $flag_mode = 3
      end
    end
  end
  
  def check_render
    #���̐�
    @check_oto.each do |i|
      i.draw
    end
    #�񎦕��@
    @check_teiji.each do |i|
      i.draw
    end
    #�����̎��
    @check_moji.each do |i|
      i.draw
    end
    #���C�P�����[�h
    if $flag_oto == 1
      @check_mode.each do |i|
        i.draw
      end
    end
  end
  
end

####################################################################################################
class Title_Scene < Scene::Base
  def init
    @btn_start = Button.new(600, 380, "", 16,200,120,[0,255,255,255],[0,255,255,255],[0,255,255,255])
    @btn_back = Button.new(600, 510, "", 16,200,120,[0,255,255,255],[0,255,255,255],[0,255,255,255])
    @btn_end = Button.new(600, 650, "", 16,200,120,[0,255,255,255],[0,255,255,255],[0,255,255,255])
    @image = Image.load("image/back_ground.png", 0, 0, 1024, 768)
    @gun = Gun_cursor.new#�e�e�ɐ���������ق�����������
    $count = 0        # �Q�[���̉�
    $score = 100        # �_��
  end
  
  def update
    self.next_scene = Present_Scene if @btn_start.pushed?
    self.next_scene = Setup_Scene if @btn_back.pushed?
    exit if @btn_end.pushed?
    @gun.update
    #screen_shot
  end
  
  def screen_shot# �X�N���[���V���b�g�@�\
    if Input.keyPush?(K_F12) == true then
      if ! File.exist?("screenshot") then
        Dir.mkdir("screenshot")
      end
      Window.getScreenShot("screenshot/screenshot" + Time.now.strftime("%Y%m%d_%H%M%S") + ".jpg")
    end
  end
  
  def render
    Window.draw(0,0,@image)
    @gun.render
    @btn_start.render
    @btn_back.render
    @btn_end.render
  end
end#class
####################################################################################################
class Present_Scene < Scene::Base
  def init
    #logfile_point_open("�V���[�e�B���O")
    @btn_full = Button.new(Window_w-72*2, 0, "full/win", 16,72,36)
    @btn_esc = Button.new(Window_w-72, 0, "�I��", 16,72,36)
    @btn_start = Button.new(550, 600, "", 32,300,150,[0,255,255,255],[0,255,255,255],[0,255,255,255])
    @image = Image.load("image/wanted.png", 0, 0, 1024, 768)
    @gun = Gun_cursor.new#�e�e�ɐ���������ق�����������
    
    #�O���[�o���ϐ��ɂ��flag�쐬
    $num_select = 5 # ���D�̌�
    
    #�t�@�C����ǂݍ��ݐ����̕�������쐬
    make_question if $count == 0
    
    #Setup_Scene��$flag�ɉ����ă��\�b�h���g�p
    init_visual if $flag_teiji == 0
    init_hearing if $flag_teiji == 1
    init_onin if $flag_mode != 0 
    
    #���ۂɖ��ƂȂ镶����̍쐬
    make_select
    
  end
  
  #���o�񎦂̏ꍇ��initialize
  def init_visual
    @font_wanted = Array.new()
    for i in 0..$question[$count].size-1
      @font_wanted[0] = Fonts.new("#{$question[$count][0]}",400,220,200) if $flag_oto == 0 #,300+144*i,400,288
      @font_wanted[i] = Fonts.new("#{$question[$count][i]}",300+144*i,230,144) if $flag_oto == 1 #,300+144*i,400,288
      #@font_wanted[i].x =Window_w/2 - 35*(@font_wanted[i].string).size/2 if $flag_oto == 0
    end
  end
  
  #���o�񎦂̏ꍇ��initialize
  def init_hearing
    @second= 0
    @btn_oto = Button.new(500, 300, "��", 32,72,32,[0,0,0])
    
    @sound_wanted = Array.new()
    for i in 0..$question[$count].size-1
      @sound_wanted[i] = Sound.new("sound/kana_sound/#{$question[$count][i]}.wav")
    end
  end
  
  #���C���[�h�̕\�����b�Z�[�W
  def init_onin
    @color_red = 255
    if $flag_mode == 1
      @font_re = Fonts.new("�����납��˂����",272,480,72,[255,0,0]) 
    elsif $flag_mode == 2
      if $question[$count].size <= 2
        $var_delete = rand(1)
      elsif $question[$count].size == 3
        $var_delete = rand(2)
      else
        $var_delete = rand(3)
      end
      @font_target = $question[$count][$var_delete]
      @font_re = Fonts.new("�u#{@font_target}�v���ʂ��Ă˂炦",272,500,50,[255,0,0]) if $flag_teiji == 0
      @font_re = Fonts.new("���ʂ��Ă˂炦",422,500,50,[255,0,0]) if $flag_teiji == 1
      @btn_delete = Button.new(300, 510, "��", 32,72,32,[0,0,0]) if $flag_teiji == 1
      @sound_delete = Sound.new("sound/kana_sound/#{@font_target}.wav")
    elsif $flag_mode == 3
      if $question[$count].size <= 2
        @arr_delete = %w(�͂��߂� ��������)
        $var_delete = rand(1)
      elsif $question[$count].size == 3
        @arr_delete = %w(�͂��߂� �܂�Ȃ��� ��������)
        $var_delete = rand(2)
      else
        @arr_delete = %w(�͂��߂� 2�Ԗڂ� 3�Ԗڂ� ��������)
        $var_delete = rand(3)
      end
      
      @font_re = Fonts.new("#{@arr_delete[$var_delete]}�������˂����",272,500,50,[255,0,0]) 
    end
  end
  
  #�t�@�C���ǂݍ���
  def load_datafile(filename)
    array = []
    open(filename) do |file|
      while l = file.gets
        array.push l.chomp.split(//s)
      end
    end
    return array
  end
  
  #�e�L�X�g�t�@�C�����琳���ƂȂ镶���z��($question)�����o��
  def make_question
    arr_oto = %w(�P�� �P��)
    arr_font = %w(�Ђ炪�� �J�^�J�i �A���t�@�x�b�g�� �A���t�@�x�b�g��)#���������ɔ��W���Ă��Ђ炪�ȂőΉ��ł���͂�
    $question = load_datafile("question/#{arr_oto[$flag_oto]}(#{arr_font[$flag_moji]}).txt")#���쐬
    #p $question
  end
  
  #�I����($arr_select)���쐬
  def make_select
    arr_moji = Array.new()
    arr_moji[0] = %w(�� �� �� �� �� �� �� �� �� �� �� �� �� �� �� �� �� �� �� �� �� �� �� �� �� �� �� �� �� �� �� �� �� �� �� �� �� �� �� �� ��)
    arr_moji[1] = %w(�A �C �E �G �I �J �L �N �P �R �T �V �X �Z �\ �^ �` �c �e �g �i �j �k �l �m �n �q �t �w �z �} �~ �� �� �� �� �� �� �� �� ��)
    arr_moji[2] = %w(A B C D E F G H I J K L M N O P Q R S T U V W X Y Z)
    arr_moji[3] = %w(a b c d e f g h i j k l m n o p q r s t u v w x y z)
    
    #�����Q���琳�𕶎����폜
    for i in 0..$question[$count].size - 1
      arr_moji[$flag_moji].delete($question[$count][i])
    end
    arr_others = arr_moji[$flag_moji].sort_by{rand}
    
    #�I�����̕���������z��
    $arr_select = Array.new()
    
    #���D�̒��ɏ������𕶎�������
    for i in 0..$question[$count].size-1
      $arr_select.push($question[$count][i]) if $flag_mode == 0 #������push���\�b�h��unshift���\�b�h�Ɛ؂�ւ��邱�Ƃɂ���ď���,�t���̋�ʂ��e�Ղɂł���͂�
      $arr_select.unshift($question[$count][i]) if $flag_mode == 1 #�t��
    end
    
    #���D�̒��ɏ������𕶎�������(�폜�ۑ�)
    if $flag_mode == 2
      arr_dammy = Marshal.load(Marshal.dump($question[$count])) #$question[$count]�̕ۑ��p�_�~�[�z��arr_dammy���쐬
      $question[$count].delete_at($var_delete)
      for i in 0..$question[$count].size-1
        $arr_select.push($question[$count][i])
      end
      p $var_delete
      p $arr_select
      $arr_select.push(arr_dammy[$var_delete])
      p $arr_select
    end
    
    #���D�̒��ɏ������𕶎�������(���o�ۑ�)
    if $flag_mode == 3
      arr_dammy = Marshal.load(Marshal.dump($question[$count])) #$question[$count]�̕ۑ��p�_�~�[�z��arr_dammy���쐬
      arr_dammy.delete_at($var_delete) #arr_dammy���璊�o���ׂ��������폜����
      $arr_select.push($question[$count][$var_delete])#���o���ׂ��������擪�ɂȂ�悤��$arr_select�ɓ����
      for i in 0..arr_dammy.size-1
        $question[$count].delete(arr_dammy[i])#$question[$count]���琳�𕶎��ȊO���폜������̓Q�[���V�[���Ő����𒊏o���ׂ����������ɂ��邽��
      end
      
      for i in 0..arr_dammy.size-1
        $arr_select.push(arr_dammy[i]) 
      end
      p $arr_select
      p $question[$count]
    end
    #���D�̒��ɏ����s���𕶎�������
    for i in 0..$num_select-$arr_select.size-1
      $arr_select.push(arr_others[i])
    end
  end
  
  def update
    if @btn_full.pushed?
      if Window.windowed?
        Window.windowed = false
      else
        Window.windowed = true
      end
    elsif @btn_esc.pushed?
      exit
    end
    
    update_hearing if $flag_teiji == 1
    update_onin if $flag_mode != 0 
    
    self.next_scene = Game_Scene if @btn_start.pushed?
    
    @gun.update
  end
  
  #���o�񎦂̏ꍇ�̏���
  def update_hearing
    for i in 0..@sound_wanted.size-1
      @sound_wanted[i].play if @second == 50*i
    end
    @second += 1
    @second = 0 if @btn_oto.pushed?
    if $flag_mode == 2
      @sound_delete.play if @btn_delete.pushed?
    end
  end
  
  #���C���[�h�̏ꍇ�̏���
  def update_onin
    @color_red += 1
    if @color_red % 15 == 0
      @font_re = Fonts.new("",272,480,72,[255,0,0]) if $flag_mode == 1
      @font_re = Fonts.new("",272,500,50,[255,0,0]) if $flag_mode == 2
      @font_re = Fonts.new("",272,500,50,[255,0,0]) if $flag_mode == 3
    else
      @font_re = Fonts.new("�����납��˂����",232,480,72,[0,0,0]) if $flag_mode == 1
      @font_re = Fonts.new("�u#{@font_target}�v���ʂ��Ă˂炦",272,500,50,[255,0,0]) if $flag_mode == 2 and $flag_teiji == 0
      @font_re = Fonts.new("���ʂ��Ă˂炦",424,500,50,[255,0,0]) if $flag_mode == 2 and $flag_teiji == 1
      @font_re = Fonts.new("#{@arr_delete[$var_delete]}�������˂����",272,500,50,[0,0,0]) if $flag_mode == 3
    end
  end
  
  def render
    Window.draw(0,0,@image)
    @btn_start.render
    @btn_full.render
    @btn_esc.render
    @font_re.render if $flag_mode != 0 #,300+144*i,400,288
    #@btn_delete if $flag_mode == 2 and $flag_teiji == 1
    #�񎦕��@�ɂ�镪��
    if $flag_teiji == 0
      @font_wanted.each do |i|
        i.render
      end
    elsif $flag_teiji == 1
      @btn_oto.render
      @btn_delete.render if $flag_mode == 2 
    end
    @gun.render
  end
  
end
####################################################################################################
class Game_Scene < Scene::Base
  def init
    @num=$question.size/5
    @arr_haikei=Array.new()
    for i in 0..$question.size-1
      if (0..@num-1).include?(i)
        @arr_haikei[i]=0
      elsif (@num..@num*1).include?(i)
        @arr_haikei[i]=1
      elsif (@num+1..@num*2).include?(i)
        @arr_haikei[i]=2
      elsif (@num*2+1..@num*3).include?(i)
        @arr_haikei[i]=3
      elsif (@num*3+1..@num*4).include?(i)
        @arr_haikei[i]=4
      else
        @arr_haikei[i]=4
      end
    end
    @image = Image.load("image/bg_#{@arr_haikei[$count]}.png", 0, 0, 1024, 768)#{$count}
    @gun = Gun_cursor.new#�e�e�ɐ���������ق�����������
    @bgm = Sound.new("sound/kujira.mid")
    #@bgm.setVolume(200)
    @bgm.play
    @sound_ok = Sound.new("sound/seikai.wav")
    @sound_bad = Sound.new("sound/hazure.wav")
    @flag_push = :off
    
    make_baloon
    init_tango if $flag_oto == 1
    log_string
    S_Timer.reset
    @font_time = Fonts.new("0",0,0,50,Black)
  end
  
  #�P��̎���initialize
  def init_tango
    @arr_dammy = Array.new($question[$count].size,0)
    @arr_correct = Array.new($question[$count].size,1)
  end
  
  #���D�����
  def make_baloon
    #�ȉ��̏����͕��D�̐�($num_select)��5�Ɖ���
    @baloon = Array.new()
    @baloon_x = [100,300,500,700,900]
    @baloon_x = @baloon_x.sort_by{rand}
    @baloon_y = [768,768,768,768,768]
    @baloon_y = @baloon_y.sort_by{rand}
    for i in 0..$num_select-1
      @baloon[i] = Baloon.new(@baloon_x[i], @baloon_y[i],$arr_select[i],i)
    end
  end
  
  #log�ɏ�����镶���̔z��
  def log_string
    @string_oto =%w(�P�� 2���ȏ�)
    @string_teiji =%w(���o ���o)
    @string_moji =%w(�Ђ炪�� �J�^�J�i �A���t�@�x�b�g�� �A���t�@�x�b�g��)
    @string_mode =%w(���� �t�� �폜 ���o)
  end
  
  def update
    #$file_point.puts "#{S_Timer.get},#{@gun.x},#{@gun.y},#{@baloon[0].font},#{@baloon[0].x},#{@baloon[0].y},#{@baloon[1].font},#{@baloon[1].x},#{@baloon[1].y},#{@baloon[2].font},#{@baloon[2].x},#{@baloon[2].y},#{@baloon[3].font},#{@baloon[3].x},#{@baloon[3].y},#{@baloon[4].font},#{@baloon[4].x},#{@baloon[4].y}"
    update_tanon if $flag_oto == 0#�P���̏ꍇ�̐��𔻒�
    update_tango if $flag_oto == 1#2���ȏ�̏ꍇ�̐��𔻒�
    @font_time = Fonts.new("����#{20-S_Timer.get.round}�b",0,0,50,White)
    @time =  S_Timer.get
    if @time >= 20
      $score -= 100/$question.size if @flag_push == :off
      self.next_scene = Present_Scene#Commentbad_Scene
      @sound_bad.play
      @bgm.stop
      $count += 1
    end
    @gun.update
    @baloon.each do |i|
      i.update
    end
  end
  
  #�P���̏ꍇ�̏���
  def update_tanon
    #�����̕��D�����������̏���
    if @baloon[0].pushed?
      @baloon[0] = Baloon.new(@baloon_x[0], @baloon_y[0],$arr_select[0],0,1)#���D�j��
      $file.puts "#{@string_oto[$flag_oto]},#{@string_teiji[$flag_teiji]},#{@string_moji[$flag_moji]},#{@string_mode[$flag_mode]},#{$count},#{$arr_select[0]},#{S_Timer.get},��"
      @sound_ok.play
      @bgm.stop
      #$score += 20 if @flag_push == :off
      
      if $count < $question.size-1
        self.next_scene = Present_Scene #if @flag_push == :off
        #self.next_scene = Commentbad_Scene if @flag_push == :on
        @bgm.stop
        $count += 1
      else
        self.next_scene = End_Scene 
        @bgm.stop
      end
    end
    
    #�s�����̕��D�����������̏���
    for i in 1..$num_select-1
      if @baloon[i].pushed?
        $score -= 100/$question.size if @flag_push == :off
        @flag_push = :on
        @sound_bad.play
        @baloon[i].color
        #@baloon[i] = Baloon.new(@baloon_x[i], @baloon_y[i],$arr_select[i],i,1)#���D�j��
        $file.puts "#{@string_oto[$flag_oto]},#{@string_teiji[$flag_teiji]},#{@string_moji[$flag_moji]},#{@string_mode[$flag_mode]},#{$count},#{$arr_select[i]},#{S_Timer.get},�~"
      end
    end
  end
  
  #�P��̏ꍇ�̏���
  def update_tango
    #�P��̐擪�̕��������������̏���
    if @baloon[0].pushed?
      @arr_dammy[0] = 1 
        @sound_ok.play
        @baloon[0] = Baloon.new(@baloon_x[0], @baloon_y[0],$arr_select[0],0,1)
      $file.puts "#{@string_oto[$flag_oto]},#{@string_teiji[$flag_teiji]},#{@string_moji[$flag_moji]},#{@string_mode[$flag_mode]},#{$count},#{$arr_select[0]},#{S_Timer.get},��"
    end
    
    #�P��̐擪�ȊO�����������̏���
    for i in 1..$question[$count].size-1
      if @baloon[i].pushed?
        if @arr_dammy[i-1] == 1
          @arr_dammy[i] = 1
          @sound_ok.play
          @baloon[i] = Baloon.new(@baloon_x[i], @baloon_y[i],$arr_select[i],i,1)
          $file.puts "#{@string_oto[$flag_oto]},#{@string_teiji[$flag_teiji]},#{@string_moji[$flag_moji]},#{@string_mode[$flag_mode]},#{$count},#{$arr_select[i]},#{S_Timer.get},��"
        else
          @sound_bad.play
          $file.puts "#{@string_oto[$flag_oto]},#{@string_teiji[$flag_teiji]},#{@string_moji[$flag_moji]},#{@string_mode[$flag_mode]},#{$count},#{$arr_select[i]},#{S_Timer.get},�~"
        end
      end
    end
    
    #�P������ׂĊ��������̏���
    if @arr_dammy == @arr_correct
      @bgm.stop
      #$score += 20 if @flag_push == :off
      if $count < $question.size-1
        self.next_scene = Present_Scene #if @flag_push == :off
        #self.next_scene = Commentbad_Scene if @flag_push == :on
        @bgm.stop
        $count += 1
      else
        self.next_scene = End_Scene
        @bgm.stop
      end
    end
    
    #�P��ȊO�̌��t�����������̏���
    for i in $question[$count].size-1..$num_select-1
      if @baloon[i].pushed?
        $score -= 100/$question.size if @flag_push == :off
        @flag_push = :on
        @sound_bad.play
        @baloon[i].color
        $file.puts "#{@string_oto[$flag_oto]},#{@string_teiji[$flag_teiji]},#{@string_moji[$flag_moji]},#{@string_mode[$flag_mode]},#{$count},#{$arr_select[i]},#{S_Timer.get},�~"
      end
    end
    
  end
  
  
  def render
    Window.draw(0,0,@image)
    @btn_hint.render if @flag_hint == 1
    @baloon.each do |i|
      i.render
    end
    @gun.render
    @font_time.render
  end
end#class

####################################################################################################
class Commentbad_Scene < Scene::Base
  def init 
    @image = Image.load("image/miss.png")
  end
  
  def update
    self.next_scene = Present_Scene if Input.keyDown?(K_NUMPAD0)
  end
  
  def render
    Window.draw(0,0,@image)
  end
end
####################################################################################################
class Commentok_Scene < Scene::Base
  def init 
    @image = Image.load("image/ok.png")
  end
  
  def update
    self.next_scene = Present_Scene if Input.keyDown?(K_NUMPAD0)
  end
  
  def render
    Window.draw(0,0,@image)
  end
end
####################################################################################################
class End_Scene < Scene::Base
  def init
    @tensuu = 0
    @image = Image.load("image/score.png", 0, 0, 1024, 768)
    @btn_back = Button.new(250, 550, "", 32,200,130,[0,255,255,255],[0,255,255,255],[0,255,255,255])
    @btn_end = Button.new(620, 550, "", 32,200,130,[0,255,255,255],[0,255,255,255],[0,255,255,255])
    @gun = Gun_cursor.new#�e�e�ɐ���������ق�����������
  end
  
  def update
    @tensuu += 1
    @font_score = Fonts.new("#{@tensuu.round}",350,250,144,Black) if @tensuu <= $score
    self.next_scene = Title_Scene if @btn_back.pushed?
    exit if @btn_end.pushed?
    @gun.update
  end
  
  def render
    Window.draw(0,0,@image)
    @btn_back.render
    @btn_end.render
    @font_score.render
    @gun.render
  end
end
########################################################
########################################################
Scene.main_loop Title_Scene, FPS, 1
