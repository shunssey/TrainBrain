#!ruby -Ks
require "dxruby"
require "sdl"
require "fileutils"
#require "lib/help_button_DX"
require "lib/dx_button"
#require "lib/add_letter"

#$frame = [450,100,850,850]
$frame = [450,80,500,500]

SCREEN_W = 1280
SCREEN_H = 760
#SCREEN_W = 1680
#SCREEN_H = 1050
Window.resize(SCREEN_W, SCREEN_H) #�E�B���h�E�E�T�C�Y�̐ݒ�
Window.caption = "�w�`��\�t�g"
Window.x ,Window.y = 10, 10 #�E�B���h�E�̕\���ʒu��ݒ�
Window.bgcolor = [250,250,180] #�E�B���h�E�̔w�i�F

#$fontname = "EPSON���ȏ���M"
#Font.install("lib/epkyouka.ttf") # EPSON���ȏ���M
$fontname = "���ԊۃS�V�b�NL"
Font.install("lib/brtoulw0.ttf") # ���ԊۃS�V�b�N

SDL.init(SDL::INIT_EVERYTHING)

class Screen
  def initialize
    self.init
    self.load_question
    self.create_Button
    
    @canvas_x = $frame[0]
    @canvas_y = $frame[1]
    @size     = $frame[2]
    @font = Font.new(30)
    if $fontname == "���ԊۃS�V�b�NL"
      @font_q = Font.new(@size, "���ԊۃS�V�b�NL")
    else
      @font_q = Font.new(@size, "EPSON ���ȏ��̂l")
    end
    
    @pen = Image.load("image/pen.jpg")
    @delete = Image.load("image/delete.jpg")
    
    @frame_canvas = Image.new(@size+10, @size+10, [0,0,0])
    @frame_pen = Image.new(54,54,[0,0,255])
    @canvas = Image.new(@size,@size, [255,255,255])
    self.mk_question #�L�����o�X�̍쐬
    self.draw #�X�N���[���`��
  end
  def init
    @q_count = 0
    @n_repeat = 0
    @q_num = 0
    @sample = 1
    @write_mode = :black
    @mode_question = :start
  end
  
  def load_question
    file = File.open("config.ini","r")
    data = file.readlines
    file.close
    @q = data[0].chomp.split(",")
    tmp = @q[0].split(//)
    @q[0] = tmp[tmp.size-1]
    @log_flag = data[1].delete("log:").chomp.to_i
    @repeat = data[2].delete("�J��Ԃ���:").chomp.to_i
    @size_pen = data[3].delete("�y���̑���:").chomp.to_i
  end
  
  def create_Button
    #@help = HelpButtn.new
    @start_btn = Button.new("�͂��߂�",50,350,120,40,25)
    @black_btn = Button.new("����҂�",50,80,120,40,25)
    @white_btn = Button.new("�����S��",50,140,120,40,25)
    @init_btn = Button.new("�V����",50,250,120,40,25)
    @decide_btn = Button.new("����",50,400,120,40,25)
    @more_on  = Button.new("���{����ł�����x",50,140,220,40,22)
    @more_off = Button.new("���{�Ȃ��ł�����x",50,200,220,40,22)
    @next_kanji = Button.new("���̊�����",50,450,140,40,22)
    @exit_btn =  Button.new("�I���",400,350,120,40,25)
  end
  
  def mk_question
    @canvas.fill([255,255,255]) #���Z�b�g
    if @sample == 1 #���{�̕\��
      @canvas.drawFont(0,0,@q[@q_count],@font_q,[200,200,200])
    end
    #�����̃L�����o�X���쐬
    @alpha = Image.new(@size,@size,[255,255,255])
    @alpha.setColorKey([255,255,255])
    #���ʕ\���p
    @alpha_true = @alpha.clone
    @alpha_true.drawFont(0,0,@q[@q_count],@font_q,[255,0,0])
    
    #���O�t�@�C���̐ݒ�
    date = Time.now.strftime("%m%d_%H%M")
    if @n_repeat<10
      n = "0" + (@n_repeat+1).to_s
    else
      n = (@n_repeat+1).to_s
    end
    if @sample == 0
      number = n + "_���{�Ȃ�"
    else
      number = n + "_���{����"
    end
    $filename = "log/�w�`��_" + @q[@q_count] + "_" + number + "_" + date.to_s + "_" + ".csv"
    if @log_flag == 1
      file = open($filename,"w")
      file.puts "frame,#{@canvas_x},#{@canvas_y},#{@size},#{@size}"
      file.puts "font,#{$fontname}"
      file.puts "pen,#{@size_pen}"
      file.close
    end
    
    #���Ԃ̐ݒ�
    @first_time = SDL.getTicks/1000.0
  end
  
  def draw
    case @mode_question
    when :start
      self.start
    when :stand_by
      self.stand_by
    when :question
      self.question
    when :final
      self.final
    end
  end
  
  #�������
  def start #screen
    @start_btn.render
  end
  
  def stand_by #screen
    Window.draw(@canvas_x-5,@canvas_y-5,@frame_canvas)
    Window.draw(@canvas_x,@canvas_y,@canvas)
    Window.draw(@canvas_x,@canvas_y,@alpha_true)
    Window.draw(@canvas_x,@canvas_y,@alpha)
    @more_off.render if @n_repeat > @repeat - 2
    @more_on.render
    @next_kanji.render
  end
  
  def question #screen
    @black_btn.render
    @white_btn.render
    @init_btn.render
    @decide_btn.render
    Window.draw(@canvas_x-59,@canvas_y-5,@frame_pen)
    if @write_mode == :black
      Window.draw(@canvas_x-57,@canvas_y-3,@pen)
    else
      Window.draw(@canvas_x-57,@canvas_y-3,@delete)
    end
    Window.draw(@canvas_x-5,@canvas_y-5,@frame_canvas)
    Window.draw(@canvas_x,@canvas_y,@canvas)
    Window.draw(@canvas_x,@canvas_y,@alpha)
  end
  
  def final #screen
    @exit_btn.render
  end
  
  def click_check(x,y)
    case @mode_question
    when :start
      self.click_check_start(x,y)
    when :stand_by
      self.click_check_stand_by(x,y)
    when :question
      self.click_check_question(x,y)
    when :final
      self.click_check_final(x,y)
    end
  end
  
  def click_check_start(x,y)
    if @start_btn.pushed?(x,y)
      #�͂��߂�
      @mode_question = :question
      self.draw
    end
  end
  
  def click_check_stand_by(x,y)
    if @more_off.pushed?(x,y)
      #���{�Ȃ��ł�����x
      if @n_repeat > @repeat - 2
        @n_repeat += 1
        @sample = 0
        @mode_question = :question
        self.mk_question
        self.draw
      end
    elsif @more_on.pushed?(x,y)
      #���{����ł�����x
      @n_repeat += 1
      @sample = 1
      @mode_question = :question
      self.mk_question
      self.draw
    elsif @next_kanji.pushed?(x,y)
      #���̊�����
      @q_count += 1
      if @q_count >= @q.size
        @mode_question = :final
        self.draw
      else
        @n_repeat = 0
        @sample = 1
        @mode_question = :question
        self.mk_question
        self.draw
      end
    end
  end
  
  def click_check_question(x,y)
    if @decide_btn.pushed?(x,y)
      #����{�^��
      @mode_question = :stand_by
      self.draw
    elsif @black_btn.pushed?(x,y)
      #����҂{�^��
      @write_mode = :black
      self.draw
    elsif @white_btn.pushed?(x,y)
      #�����S���{�^��
      @write_mode = :white
      self.draw
    elsif @init_btn.pushed?(x,y)
      #�͂��߂���{�^��
      @alpha = Image.new(@size,@size,[255,255,255])
      @alpha.setColorKey([255,255,255])
      self.write_init
      self.draw
    end
  end
  
  def click_check_final(x,y)
    if @exit_btn.pushed?(x,y)
      #�I���
      exit
    end
  end
  
  def loop
    Window.loop do
      if Input.keyPush?(K_ESCAPE)
        exit
      elsif Input.mousePush?(M_LBUTTON)
          # Click�`�F�b�N
          click_check(Input.mousePosX, Input.mousePosY)
      elsif @mode_question == :question
         if Input.mouseDown?(M_LBUTTON)
           x = Input.mousePosX - @canvas_x
           y = Input.mousePosY - @canvas_y
           if (0..@size).include?(x) and (0..@size).include?(y)
              if @write_mode == :black
                @alpha.circleFill(x,y, @size_pen, [0,0,0])
              elsif @write_mode == :white
                @alpha.circleFill(x,y, @size_pen, [255,0,0])
                @alpha.setColorKey([255,0,0])
              end
              self.write_log(x,y,@write_mode)
              self.draw
           else
              @flag_write = false
           end
         else
           @flag_write = false
         end
      end
    end
  end
  
  def write_log(x,y,mode)
    time = SDL.getTicks/1000.0 - @first_time
    time_now = Time.new.strftime("%H:%M:%S")
    log = "#{x},#{y},#{time},#{mode},#{time_now}"
    #p log
    if @log_flag == 1
      file = open($filename,"a")
      file.puts log
      file.close
    end
  end
  
  def write_init
    #time = SDL.getTicks/1000.0 - @first_time
    #p "init"
    if @log_flag == 1
      file = open($filename,"a")
      file.puts "init"
      file.close
    end
  end
  
  def get_FilePath(path, mode="normal")
    ary = Dir.entries(path)
    ary.delete(".") if ary.include?(".")
    ary.delete("..") if ary.include?("..")
    ary.delete("Thumbs.db") if ary.include?("Thumbs.db")
    if mode == "name_only" #�g���q���폜
      for i in 0 .. ary.size-1
        ary[i] = ary[i].delete(File.extname(ary[i]))
      end
    elsif mode == "image" # �摜�݂̂ɂ���
      del = []
      for i in 0 .. ary.size-1
        del << ary[i] unless ary[i].include?("png")
        del << ary[i] unless ary[i].include?("jpg")
        del << ary[i] unless ary[i].include?("jpeg")
        del << ary[i] unless ary[i].include?("bmp")
      end
      if del.size > 0
        for i in 0 .. del.size-1
          ary.delete(del[i])
        end
      end
    elsif mode == "Dir" # �f�B���N�g���݂̂ɂ���
      del = []
      for i in 0 .. ary.size-1
        del << ary[i] unless File.directory?(path + ary[i])
      end
      if del.size > 0
       for i in 0 .. del.size-1
         ary.delete(del[i])
       end
      end
    end
    return ary
  end
end


screen = Screen.new
screen.loop

