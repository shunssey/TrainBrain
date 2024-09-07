#!ruby -Ks
#exerbで固めたexeから起動するときカレントディレクトリをexeのパスにする
if defined?(ExerbRuntime)
  Dir.chdir(File.dirname(ExerbRuntime.filepath))
end
######################################################
require 'dxruby'
require 'lib/scene.rb'
require 'lib/button.rb'
require 'lib/font.rb'
######################################################
Black = [0, 0, 0,]
White = [255, 255, 255]
Green = [0, 255, 0]
Blue = [0, 0, 255]
Red = [255, 0, 0]
Orange = [255, 255, 0]
Gray = [220, 220, 220]
######################################################
Window_w = 1024
Window_h = 768
Window.width  = Window_w
Window.height = Window_h
Window.bgcolor = White
#Window.x = 0
#Window.y = 0
#Window.scale = 1.5
Window.caption = "文字ひろい" 
Window.fps = 60
Window.frameskip = true
######################################################
#logディレクトリがなければ作成
if FileTest.exist?("ran") == false
  Dir::mkdir("ran")
end
#######################################################
class S_Timer
  def self.reset  #時間を初期化
    @start_time = Time.now
  end

  def self.get  #経過時間を得る
    return Time.now - @start_time
  end 
end
########################################################
class Title_Scene < Scene::Base
  def init
    @btn_esc = Button.new(Window_w-72, 0, "終了", 16,72,36)
    @title = Fonts.new("文字ひろい",0,50)
    @title.x =Window_w/2 - 35*(@title.string).size/2
    #@btn_result = Button.new(Window_w/2-72, Window_h/2+320, "成績表示",36,164,52)
    btn_make
    #font_make
  end
  
  
  def btn_make
    $ran_array = load_datafile("ran/ini.txt")
    $ran_button = Array.new()
    array = ["プリントアウトして行う","PCで行う"]
    
    y_count=0
    for i in 0..$ran_array.size-1
      $ran_button[i] = Button.new(Window_w/2 - 150, Window_h/2-100 + i * 100, "#{array[i]}",25,300,72)
=begin
      p $ran_array
      if FileTest.exist?("image/#{$ran_array[i][3]}") == true
        $ran_button[i].image = "image/#{$ran_array[i][3]}"
      else
        $ran_button[i].image = "image/no_image.png"
      end
=end
      y_count+=1  if i%4 == 3
    end
  end
  
  def font_make
    $ran_font = Array.new()
    y_count=0
    for i in 0..$ran_array.size-1
      $ran_font[i] = Fonts.new("#{$ran_array[i][2]}",90+(i%4)*250, 350+250*y_count,25)
      y_count+=1  if i%4 == 3
    end
  end

  def load_datafile(filename)
    array = []
    open(filename) do |file|
      while l = file.gets
         array.push l.chomp.split(",")
      end
    end
    return array
  end
  
  def update
    if @btn_esc.pushed?
      exit
    end
    for i in 0..$ran_array.size-1
      if $ran_button[i].pushed?
      #視線マウスの決定方法が別アプリじゃなかった場合
        @my_pid = Process.pid
        $cmd = IO.popen("./ran/#{$ran_array[i][0]}/#{$ran_array[i][1]}.exe #{@my_pid}")
        exit
      
      end
    end          
    #self.next_scene = Result_Scene  if  @btn_result.pushed?
  end

  def render
    @btn_esc.render
   # @btn_result.render
    @title.render
    $ran_button.each do |i|
      i.render
    end
    #$ran_font.each do |i|
     # i.render
    #end
  end
end

class Result_Scene < Scene::Base
  def init
    @btn_esc = Button.new(Window_w-72, 0, "終了", 16,72,36)
    @title = Fonts.new("成績発表",0,50)
    @title.x =Window_w/2 - 35*(@title.string).size/2
    @btn_end = Button.new(Window_w/2-72, Window_h/2+320, "終了",36,164,52)
    log_search
    log_font
  end

  def log_search
    @result_array = Array.new()
    for i in 0..$ran_array.size-1
      @fname = "ran/#{$ran_array[i][0]}/log/#{Time.now.strftime("%Y.%m.%d")}_result.txt"
      if FileTest.exist?("#{@fname}") == true
        array = load_datafile("#{@fname}")
        array.flatten!
        @result_array[i] = array
      else
        @result_array[i] = [" "," "]
      end
    end
  end
  
  def log_font
    $font_log1 = Array.new()
    $font_log2 = Array.new()
    y_count = 0
    for i in 0..$ran_array.size-1
      if @result_array[i][0]
        $font_log1[i] = Fonts.new("#{@result_array[i][0]}",90+(i%4)*250, 380+250*y_count,25)
      else
        $font_log1[i] = Fonts.new("  ",90+(i%4)*250, 380+250*y_count,25)
      end
      if @result_array[i][1]
        $font_log2[i] = Fonts.new("#{@result_array[i][1]}",90+(i%4)*250, 410+250*y_count,25)
      else
        $font_log2[i] = Fonts.new("  ",90+(i%4)*250, 410+250*y_count,25)
      end
      y_count+=1  if i%4 == 3
    end
  end
  
  def load_datafile(filename)
    array = []
    open(filename) do |file|
      while l = file.gets
         array.push l.chomp.split(",")
      end
    end
    return array
  end
  
  def update
    if @btn_esc.pushed?
      exit
    end
    exit  if  @btn_end.pushed?
  end

  def render
    @btn_end.render
    @btn_esc.render
    @title.render
    $ran_button.each do |i|
      i.render
    end
    $ran_font.each do |i|
      i.render
    end
    $font_log1.each do |i|
      i.render
    end
    $font_log2.each do |i|
      i.render
    end
  end
end
########################################################
########################################################
Scene.main_loop Title_Scene
