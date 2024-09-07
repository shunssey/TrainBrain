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
  def config_init
    @config_title = Images.new(Window_w/2-150, 0, 300, 100, "�ݒ���", 50, Cream, Black) 
    #�P�ꐔ�̒�`
    $word_count = 1
    @word_countup_fonts = Fonts.new(50, 200, "�E�L���P�ꐔ", 50, Black) 
    @word_countup = Images.new(350, 200, 100, 100, "#{$word_count}", 50, Cream, Black)
    @word_countup_button = Button.new( 350, 150, 100, 50, "��", 50, Gray, Black)
    @word_countdown_button = Button.new( 350, 300, 100, 50, "��", 50, Gray, Black)
    #�X�̐��̒�`
    $shop_count = 1
    @shop_countup_fonts = Fonts.new(50, 450, "�E�X�̐�", 50, Black) 
    @shop_countup = Images.new(350, 450, 100, 100, "#{$shop_count}", 50, Cream, Black)
    @shop_countup_button = Button.new( 350, 400, 100, 50, "��", 50, Gray, Black)
    @shop_countdown_button = Button.new( 350, 550, 100, 50, "��", 50, Gray, Black)
    #�ǉ��P�ꐔ�̒�`
    $word_addition_count = 0
    @word_addition_countup_fonts = Fonts.new(500, 200, "�E�ǉ��P���", 50, Black) 
    @word_addition_countup = Images.new(850, 200, 100, 100, "#{$word_addition_count}", 50, Cream, Black)
    @word_addition_countup_button = Button.new( 850, 150, 100, 50, "��", 50, Gray, Black)
    @word_addition_countdown_button = Button.new(850, 300, 100, 50, "��", 50, Gray, Black)
    #�폜�P�ꐔ�̒�`
    $word_delete_count = 0
    @word_delete_countup_fonts = Fonts.new(500, 450, "�E�폜�P���", 50, Black) 
    @word_delete_countup = Images.new(850, 450, 100, 100, "#{$word_delete_count}", 50, Cream, Black)
    @word_delete_countup_button = Button.new( 850, 400, 100, 50, "��", 50, Gray, Black)
    @word_delete_countdown_button = Button.new(850, 550, 100, 50, "��", 50, Gray, Black)
    #���̑��̒�`
    @next_button = Button.new(Window_w-100, Window_h-100, 100, 100, "����", 24, Gray, Black)
    @back_button = Button.new(0, Window_h-100, 100, 100, "�߂�", 24, Gray, Black)
  end
  
  def config_update
    #p $word_count
    #�P�ꐔ�̃J�E���g
    if @word_countup_button.pushed? && $word_count<= 8 #$word_count�̐���
      $word_count += 1
      p "$word_count = #{$word_count}"
      @word_countup = Images.new(350, 200, 100, 100, "#{$word_count}", 50, Cream, Black)
    end
    
    if @word_countdown_button.pushed? && $word_count >= 2
      $word_count -= 1
      p "$word_count = #{$word_count}"
      @word_countup = Images.new(350, 200, 100, 100, "#{$word_count}", 50, Cream, Black)
      if $shop_count > $word_count
        $shop_count = $word_count
        @shop_countup = Images.new(350, 450, 100, 100, "#{$shop_count}", 50, Cream, Black)
      end
    end
    
    #�X�̃J�E���g
    if @shop_countup_button.pushed? && $shop_count <= 5
      $shop_count += 1
      p "$shop_count = #{$shop_count}"
      @shop_countup = Images.new(350, 450, 100, 100, "#{$shop_count}", 50, Cream, Black)
      if $shop_count > $word_count
        $word_count = $shop_count
        p "$word_count = #{$word_count}"
        p "$shop_count = #{$shop_count}"
        @word_countup = Images.new(350, 200, 100, 100, "#{$word_count}", 50, Cream, Black)
      end
    end
    
    if @shop_countdown_button.pushed? && $shop_count >= 2 
      $shop_count -= 1
      p "$shop_count = #{$shop_count}"
      @shop_countup = Images.new(350, 450, 100, 100, "#{$shop_count}", 50, Cream, Black)
    end
    
    #�ǉ��P��̃J�E���g
    if @word_addition_countup_button.pushed? 
      $word_addition_count += 1
      @word_addition_countup = Images.new(850, 200, 100, 100, "#{$word_addition_count}", 50, Cream, Black)
    end
    
    if @word_addition_countdown_button.pushed? 
      $word_addition_count -= 1
      @word_addition_countup = Images.new(850, 200, 100, 100, "#{$word_addition_count}", 50, Cream, Black)
    end
    
    #�폜�P��̃J�E���g
    if @word_delete_countup_button.pushed? 
      $word_delete_count += 1
      @word_delete_countup = Images.new(850, 450, 100, 100, "#{$word_delete_count}", 50, Cream, Black)
    end
    
    if @word_delete_countdown_button.pushed? 
      $word_delete_count -= 1
      @word_delete_countup = Images.new(850, 450, 100, 100, "#{$word_delete_count}", 50, Cream, Black)
    end
    
    #���̑�
    if @next_button.pushed?
      #self.next_scene = Main_Scene 
      self.next_scene = Main_Scene
    end
    
    if @back_button.pushed?
      self.next_scene = Title_Scene
    end
  end
  
  def config_render
    #�P�ꐔ�̒�`
    @word_countup_fonts.render
    @word_countup.render
    @word_countup_button.render
    @word_countdown_button.render
    #���X�̒�`
    @shop_countup_fonts.render
    @shop_countup.render
    @shop_countup_button.render
    @shop_countdown_button.render
    #�ǉ��P��̒�`
    @word_addition_countup_fonts.render
    @word_addition_countup.render
    @word_addition_countup_button.render
    @word_addition_countdown_button.render
    #�폜�P��̒�` $shop_count
    @word_delete_countup_fonts.render
    @word_delete_countup.render
    @word_delete_countup_button.render
    @word_delete_countdown_button.render
    #���̑��̒�`
    @config_title.render
    @next_button.render
    @back_button.render
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
