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

class Init_Scene  < Scene::Base
  def show_init
    Anime_Timer.reset
    p @time_count = 20
    $takarabako_teiji = [["�Ԃ��󔠂�","���󔠂�","���F���󔠂�","�s���N�F�̕󔠂�","�ΐF�̕󔠂�"],[Red,Blue,Yellow,Pink,Green]]
    $key_teiji = [["�Ԃ����ŊJ��","�����ŊJ��","���F�����ŊJ��","�s���N�F�̌��ŊJ��","�ΐF�̌��ŊJ��"],[Red,Blue,Yellow,Pink,Green]]
    $takarabako_teiji[0] = $takarabako_teiji[0].shuffle
    $key_teiji[0] = $key_teiji[0].shuffle
    for i in 0..$takarabako_number
      $takarabako_teiji[1][i] =  $key_teiji[0][i]
    end
    $takarabako_img = Array.new
    $key_img = Array.new
    @font_ha = Array.new
    @font_hiraku = Array.new
#############################�C���[�W�╶���Ȃ�
    for i in 0..$takarabako_number
      $takarabako_img[i] = Images.new(350, 100*i+200, 90, 90, "", 24, Cream, Black)
      $key_img[i] = Images.new(600, 100*i+200, 90, 90, "", 24, Cream, Black)
      @font_ha[i] = Fonts.new(470, 100*i+215, "��", 50, White) #��
      @font_hiraku[i] = Fonts.new(725, 100*i+215, "�ŊJ��", 50, White) #�J��
    end
    @time_count_img = Images.new(100, 600, 100, 100, "#{@time_count}", 50, Cream, Black) #�b���w��
    @time_count_img.image("./image/item_window2.png") #�b���w��
    @font_ato = Fonts.new(115, 550, "����", 40, White) #��
    @font_byou = Fonts.new(210, 650, "�b", 40, White) #�J��
########################################
=begin
    @message_img = Images.new(50, 20, 500, 50, "������΂��ƃJ�M�̂��݂��킹�����ڂ��悤", 40, Cream, Black) #�g�ݍ��킹�̃��b�Z�[�W
    @message_img.image("./image/frame/frame.png")
    @message_img.font_color(White)
=end
########################################
    #�ǂ̕󔠂�I�����邩�� ����
    
    
    
    $takarabako_r = rand(5)
    for i in 0..$takarabako_number
      case $takarabako_teiji[0][i]
      when "�Ԃ��󔠂�"
        $takarabako_teiji[1][i] = Red
        $takarabako_img[i].image("./image/takarabako90/takarabako_red.png")                                                                                                                                           
      when "���󔠂�"
        $takarabako_teiji[1][i] = Blue
        $takarabako_img[i].image("./image/takarabako90/takarabako_blue.png")
      when "���F���󔠂�"
        $takarabako_teiji[1][i] = Yellow
        $takarabako_img[i].image("./image/takarabako90/takarabako_yellow.png")
      when "�s���N�F�̕󔠂�"
        $takarabako_teiji[1][i] = Pink
        $takarabako_img[i].image("./image/takarabako90/takarabako_purple.png")
      when "�ΐF�̕󔠂�"
        $takarabako_teiji[1][i] = Green
        $takarabako_img[i].image("./image/takarabako90/takarabako_green.png")
      end
    end
    
    for i in 0..$takarabako_number
      case $key_teiji[0][i]
      when "�Ԃ����ŊJ��"
        $key_teiji[1][i] = Red
        $key_img[i].image("./image/key90/key_red.png")
      when "�����ŊJ��"
        $key_teiji[1][i] = Blue
        $key_img[i].image("./image/key90/key_blue.png")
      when "���F�����ŊJ��"
        $key_teiji[1][i] = Yellow
        $key_img[i].image("./image/key90/key_yellow.png")
      when "�s���N�F�̌��ŊJ��"
        $key_teiji[1][i] = Pink
        $key_img[i].image("./image/key90/key_purple.png")
      when "�ΐF�̌��ŊJ��"
        $key_teiji[1][i] = Green
        $key_img[i].image("./image/key90/key_green.png")
      end
    end
    
    
    
    #�{�^�������
    @btn = Array.new
    
    $color = [Red,Blue,Yellow,Pink,Green]
    @img = Array.new
    @img2 = Array.new
=begin
    for i in 0..4
      @img[i] = Images.new(400, 300+50*i, 200, 50, "#{$takarabako_teij5i[0][i]}", 24, Cream, Black)
      @img2[i] = Images.new(600, 300+50*i, 200, 50, "#{$key_teiji[0][i]}", 24, Cream, Black)
    end
=end
########################################
########################################�󔠂ƌ��̑g�ݍ��킹�̃��b�Z�[�W
    @message_img = Images.new(50, 20, 500, 50, "������΂��ƃJ�M�̂��݂��킹�����ڂ��悤", 40, Cream, Black) #�g�ݍ��킹�̃��b�Z�[�W
    @message_img.image("./image/frame/frame.png")
    @message_img.font_color(White)
######################################## �́@�ŊJ��
=begin
    @message_img = Images.new(50, 20, 500, 50, "������΂��ƃJ�M�̂��݂��킹�����ڂ��悤", 40, Cream, Black) #�g�ݍ��킹�̃��b�Z�[�W
    @message_img.image("./image/frame/frame.png")
    @message_img.font_color(White)
=end
########################################
    @frame_img = Images.new(75, 150, 700, 50, "", 40, Cream, Black) #�󔠂ƌ��̑g�ݍ��킹���͂ޘg
    @frame_img.image("./image/frame/frame2.png")
########################################
  end #init
  
  def show_update
    if Anime_Timer.get >= 1
      p @time_count -= 1
      @time_count_img = Images.new(100, 600, 100, 100, "#{@time_count}", 50, Cream, Black)
      @time_count_img.image("./image/item_window2.png") #�b���w��
      Anime_Timer.reset
    end
    
    if @time_count == -1
      self.next_scene = Main_Scene
    end
    
    #self.next_scene = Main_Scene2
    
    if Input.keyPush?(K_N)
      self.next_scene = Main_Scene
    end
    
    if Input.keyPush?(K_B)
      self.next_scene = Stageselect_Scene 
    end
    
    if Input.keyPush?(K_R)
      self.next_scene = Show_Scene
    end
  end #update
  
  def show_render
    @message_img.render #�g�ݍ��킹�̃��b�Z�[�W
    @frame_img.render
    @font_ato.render #��
    @font_byou.render #�J��
    @time_count_img.render #���Ԃ̕\��
    
    for i in 0..$takarabako_number
      $key_img[i].render
      $takarabako_img[i].render
      @font_ha[i].render
      @font_hiraku[i].render
    end
  end #render
end #scene
##################################################################
