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
class Init_Scene  < Scene::Base
  
  #�^�C�g����ʂ̏��X�̒�`�@���������火
  def bunbougu_init
    scene_count = 0
    S_Timer.reset
    $file.puts",�P�P���,�I������[s]"
    @product = Array.new
    @product_image = Array.new
    @product[0] = Button.new(100, 50, 200, 200, "", 24, Gray, Black)
    @product[0].image("./image/bunbougu/ballpen.png")
    @product[1] = Button.new(400, 50, 200, 200, "", 24, Gray, Black)
    @product[1].image("./image/bunbougu/compass.png")
    @product[2] = Button.new(700, 50, 200, 200, "", 24, Blue, Black)
    @product[2].image("./image/bunbougu/enpitsu.png")
    @product[3] = Button.new(100, 300, 200, 200, "", 24, Blue, Black)
    @product[3].image("./image/bunbougu/hasami.png")
    @product[4] = Button.new(400, 300, 200, 200, "", 24, Blue, Black)
    @product[4].image("./image/bunbougu/hochikisu.png")
    @product[5] = Button.new(700, 300, 200, 200, "", 24, Blue, Black)
    @product[5].image("./image/bunbougu/jougi.png")
    @product[6] = Button.new(100, 550, 200, 200, "", 24, Blue, Black)
    @product[6].image("./image/bunbougu/keshigomu.png")
    @product[7] = Button.new(400, 550, 200, 200, "", 24, Blue, Black)
    @product[7].image("./image/bunbougu/kureyon.png")
    @product[8] = Button.new(700, 550, 200, 200, "", 24, Blue, Black)
    @product[8].image("./image/bunbougu/sticknori.png")
    $select_product = Array.new
    @select = Array.new
    @frame_count = Array.new
    for i in 0..8
      @select[i] = Images.new(100, 50, 600, 300, "", 24, Clear, Clear)
      @select[i].image("./image/select.png")
    end
    
    for i in 0..8
      @product[i].waku(Black)
      @frame_count[i] = 0
    end
  end
  
  def bunbougu_update
    if @product[0].pushed2?
      @frame_count[0] += 1
      if @frame_count[0]%2 == 1
        $buy_product[$buy_product_number] = "�{�[���y��"
        $buy_product_number += 1
        @select[0] = Images.new(100, 50, 200, 200, "", 24, Clear, Clear)
        @select[0].image("./image/select.png")
        p $select_product[0] = "�{�[���y��"
        $file.puts",�{�[���y��,#{S_Timer.get}"
      elsif
        @frame_count[0] = 0
        $buy_product_number -= 1
        $buy_product[$buy_product_number] = []
      end
    elsif @product[1].pushed2?
      @frame_count[1] += 1
      if @frame_count[1]%2 == 1
        $buy_product[$buy_product_number] = "�R���p�X"
        $buy_product_number += 1
        @select[1] = Images.new(400, 50, 200, 200, "", 24, Blue, Black)
        @select[1].image("./image/select.png")
        p $select_product[0] = "�R���p�X"
        $file.puts",�R���p�X,#{S_Timer.get}"
      elsif
        @frame_count[1] = 0
        $buy_product_number -= 1
        $buy_product[$buy_product_number] = []
      end
    elsif @product[2].pushed2?
      @frame_count[2] += 1
      if @frame_count[2]%2 == 1
        $buy_product[$buy_product_number] = "����҂�"
        $buy_product_number += 1
        @select[2] = Images.new(700, 50, 200, 200, "", 24, Blue, Black)
        @select[2].image("./image/select.png")
        p $select_product[0] = "����҂�"
        $file.puts",����҂�,#{S_Timer.get}"
      elsif
        @frame_count[2] = 0
        $buy_product_number -= 1
        $buy_product[$buy_product_number] = []
      end
    elsif @product[3].pushed2?
      @frame_count[3] += 1
      if @frame_count[3]%2 == 1
        $buy_product[$buy_product_number] = "�n�T�~"
        $buy_product_number += 1
        @select[3] = Images.new(100, 300, 200, 200, "", 24, Blue, Black)
        @select[3].image("./image/select.png")
        p $select_product[0] = "�n�T�~"
        $file.puts",�n�T�~,#{S_Timer.get}"
      elsif
        @frame_count[3] = 0
        $buy_product_number -= 1
        $buy_product[$buy_product_number] = []
      end
    elsif @product[4].pushed2?
      @frame_count[4] += 1
      if @frame_count[4]%2 == 1
        $buy_product[$buy_product_number] = "�z�`�L�X"
        $buy_product_number += 1
        @select[4] = Images.new(400, 300, 200, 200, "", 24, Blue, Black)
        @select[4].image("./image/select.png")
        p $select_product[0] = "�z�`�L�X"
        $file.puts",�z�`�L�X,#{S_Timer.get}"
      elsif
        @frame_count[4] = 0
        $buy_product_number -= 1
        $buy_product[$buy_product_number] = []
      end
    elsif @product[5].pushed2?
      @frame_count[5] += 1
      if @frame_count[5]%2 == 1
        $buy_product[$buy_product_number] = "���傤��"
        $buy_product_number += 1
        @select[5] = Images.new(700, 300, 200, 200, "", 24, Blue, Black)
        @select[5].image("./image/select.png")
        p $select_product[0] = "���傤��"
        $file.puts",���傤��,#{S_Timer.get}"
      elsif
        @frame_count[5] = 0
        $buy_product_number -= 1
        $buy_product[$buy_product_number] = []
      end
    elsif @product[6].pushed2?
      @frame_count[6] += 1
      if @frame_count[6]%2 == 1
        $buy_product[$buy_product_number] = "�����S��"
        $buy_product_number += 1
        @select[6] = Images.new(100, 550, 200, 200, "", 24, Blue, Black)
        @select[6].image("./image/select.png")
        p $select_product[0] = "�����S��"
        $file.puts",�����S��,#{S_Timer.get}"
      elsif
        @frame_count[6] = 0
        $buy_product_number -= 1
        $buy_product[$buy_product_number] = []
      end
    elsif @product[7].pushed2?
      @frame_count[7] += 1
      if @frame_count[7]%2 == 1
        $buy_product[$buy_product_number] = "�N������"
        $buy_product_number += 1
        @select[7] = Images.new(400, 550, 200, 200, "", 24, Blue, Black)
        @select[7].image("./image/select.png")
        p $select_product[0] = "�N������"
        $file.puts",�N������,#{S_Timer.get}"
      elsif
        @frame_count[7] = 0
        $buy_product_number -= 1
        $buy_product[$buy_product_number] = []
      end
    elsif @product[8].pushed2?
      @frame_count[8] += 1
      if @frame_count[8]%2 == 1
        $buy_product[$buy_product_number] = "�X�e�B�b�N�̂�"
        $buy_product_number += 1
        @select[8] = Images.new(700, 550, 200, 200, "", 24, Blue, Black)
        @select[8].image("./image/select.png")
        p $select_product[0] = "�X�e�B�b�N�̂�"
        $file.puts",�X�e�B�b�N�̂�,#{S_Timer.get}"
      elsif
        @frame_count[8] = 0
        $buy_product_number -= 1
        $buy_product[$buy_product_number] = []
      end
    end
  end
 
  def bunbougu_render
    for i in 0..8
      @product[i].render
    end
    
    for i in 0..8
      if @frame_count[i] == 1
        @select[i].render
      end
    end
  end

  #�^�C�g����ʂ̏��X�̒�`�@�������܂Ł�

  #�t�@�C����,��؂�œǂݍ���Ŕz��Ƃ��Ċi�[
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
  
  #n�~m�̑������z��𐶐����Av�ŗv�f�𖄂߂�
  def nm_array(n=1, m=1, v=nil)  
    (1..n).map {Array.new(m){v}}
  end
  
  ##########################################�@�v���O���X�o�[�@###################################################
  
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
  def self.reset  #���Ԃ�������
    @start_time = Time.now
  end

  def self.get  #�o�ߎ��Ԃ𓾂�
    return Time.now - @start_time
  end 
end

class Clear_Timer
  def self.reset  #���Ԃ�������
    @start_time = Time.now
  end

  def self.get  #�o�ߎ��Ԃ𓾂�
    return Time.now - @start_time
  end 
end

class Anime_Timer
  def self.reset  #���Ԃ�������
    @start_time = Time.now
  end

  def self.get  #�o�ߎ��Ԃ𓾂�
    return Time.now - @start_time
  end 
end
##################################################################
