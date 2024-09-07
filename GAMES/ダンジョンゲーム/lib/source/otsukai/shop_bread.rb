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
class Init_Scene  < Scene::Base
  
  #タイトル画面の諸々の定義　↓ここから↓
  def bread_init
    scene_count = 0
    S_Timer.reset
    $file.puts",１単語目,選択時間[s]"
    @product = Array.new
    @product_image = Array.new
    @product[0] = Button.new(100, 50, 200, 200, "", 24, Gray, Black)
    @product[0].image("./image/bread/anpan.png")
    @product[1] = Button.new(400, 50, 200, 200, "", 24, Gray, Black)
    @product[1].image("./image/bread/bread.png")
    @product[2] = Button.new(700, 50, 200, 200, "", 24, Blue, Black)
    @product[2].image("./image/bread/creampan.png")
    @product[3] = Button.new(100, 300, 200, 200, "", 24, Blue, Black)
    @product[3].image("./image/bread/croissan.png")
    @product[4] = Button.new(400, 300, 200, 200, "", 24, Blue, Black)
    @product[4].image("./image/bread/currypan.png")
    @product[5] = Button.new(700, 300, 200, 200, "", 24, Blue, Black)
    @product[5].image("./image/bread/francepan.png")
    @product[6] = Button.new(100, 550, 200, 200, "", 24, Blue, Black)
    @product[6].image("./image/bread/melonpan.png")
    @product[7] = Button.new(400, 550, 200, 200, "", 24, Blue, Black)
    @product[7].image("./image/bread/sandwitch.png")
    @product[8] = Button.new(700, 550, 200, 200, "", 24, Blue, Black)
    @product[8].image("./image/bread/yakisobapan.png")
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
  
  def bread_update
    if @product[0].pushed2?
      @frame_count[0] += 1
      if @frame_count[0]%2 == 1
        $buy_product[$buy_product_number] = "あんぱん"
        $buy_product_number += 1
        @select[0] = Images.new(100, 50, 200, 200, "", 24, Clear, Clear)
        @select[0].image("./image/select.png")
        p $select_product[0] = "あんぱん"
        $file.puts",あんぱん,#{S_Timer.get}"
      elsif
        @frame_count[0] = 0
        $buy_product_number -= 1
        $buy_product[$buy_product_number] = []
      end
    elsif @product[1].pushed2?
      @frame_count[1] += 1
      if @frame_count[1]%2 == 1
        p $buy_product[$buy_product_number] = "食パン"
        $buy_product_number += 1
        @select[1] = Images.new(400, 50, 200, 200, "", 24, Blue, Black)
        @select[1].image("./image/select.png")
        p $select_product[0] = "食パン"
        $file.puts",食パン,#{S_Timer.get}"
        p 111
      elsif
        @frame_count[1] = 0
        $buy_product_number -= 1
        $buy_product[$buy_product_number] = []
        p 222
      end
    elsif @product[2].pushed2?
      @frame_count[2] += 1
      if @frame_count[2]%2 == 1
        $buy_product[$buy_product_number] = "クリームパン"
        $buy_product_number += 1
        @select[2] = Images.new(700, 50, 200, 200, "", 24, Blue, Black)
        @select[2].image("./image/select.png")
        p $select_product[0] = "クリームパン"
        $file.puts",クリームパン,#{S_Timer.get}"
      elsif
        @frame_count[2] = 0
        $buy_product_number -= 1
        $buy_product[$buy_product_number] = []
      end
    elsif @product[3].pushed2?
      @frame_count[3] += 1
      if @frame_count[3]%2 == 1
        $buy_product[$buy_product_number] = "クロワッサン"
        $buy_product_number += 1
        @select[3] = Images.new(100, 300, 200, 200, "", 24, Blue, Black)
        @select[3].image("./image/select.png")
        p $select_product[0] = "クロワッサン"
        $file.puts",クロワッサン,#{S_Timer.get}"
      elsif
        @frame_count[3] = 0
        $buy_product_number -= 1
        $buy_product[$buy_product_number] = []
      end
    elsif @product[4].pushed2?
      @frame_count[4] += 1
      if @frame_count[4]%2 == 1
        $buy_product[$buy_product_number] = "カレーパン"
        $buy_product_number += 1
        @select[4] = Images.new(400, 300, 200, 200, "", 24, Blue, Black)
        @select[4].image("./image/select.png")
        p $select_product[0] = "カレーパン"
        $file.puts",カレーパン,#{S_Timer.get}"
      elsif
        @frame_count[4] = 0
        $buy_product_number -= 1
        $buy_product[$buy_product_number] = []
      end
    elsif @product[5].pushed2?
      @frame_count[5] += 1
      if @frame_count[5]%2 == 1
        $buy_product[$buy_product_number] = "フランスパン"
        $buy_product_number += 1
        @select[5] = Images.new(700, 300, 200, 200, "", 24, Blue, Black)
        @select[5].image("./image/select.png")
        p $select_product[0] = "フランスパン"
        $file.puts",フランスパン,#{S_Timer.get}"
      elsif
        @frame_count[5] = 0
        $buy_product_number -= 1
        $buy_product[$buy_product_number] = []
      end
    elsif @product[6].pushed2?
      @frame_count[6] += 1
      if @frame_count[6]%2 == 1
        $buy_product[$buy_product_number] = "メロンパン"
        $buy_product_number += 1
        @select[6] = Images.new(100, 550, 200, 200, "", 24, Blue, Black)
        @select[6].image("./image/select.png")
        p $select_product[0] = "メロンパン"
        $file.puts",メロンパン,#{S_Timer.get}"
      elsif
        @frame_count[6] = 0
        $buy_product_number -= 1
        $buy_product[$buy_product_number] = []
      end
    elsif @product[7].pushed2?
      @frame_count[7] += 1
      if @frame_count[7]%2 == 1
        $buy_product[$buy_product_number] = "サンドイッチ"
        $buy_product_number += 1
        @select[7] = Images.new(400, 550, 200, 200, "", 24, Blue, Black)
        @select[7].image("./image/select.png")
        p $select_product[0] = "サンドイッチ"
        $file.puts",サンドイッチ,#{S_Timer.get}"
      elsif
        @frame_count[7] = 0
        $buy_product_number -= 1
        $buy_product[$buy_product_number] = []
      end
    elsif @product[8].pushed2?
      @frame_count[8] += 1
      if @frame_count[8]%2 == 1
        $buy_product[$buy_product_number] = "焼きそばパン"
        $buy_product_number += 1
        @select[8] = Images.new(700, 550, 200, 200, "", 24, Blue, Black)
        @select[8].image("./image/select.png")
        p $select_product[0] = "焼きそばパン"
        $file.puts",焼きそばパン,#{S_Timer.get}"
      elsif
        @frame_count[8] = 0
        $buy_product_number -= 1
        $buy_product[$buy_product_number] = []
      end
    end
  end
 
  def bread_render
    for i in 0..8
      @product[i].render
    end
    
    for i in 0..8
      if @frame_count[i] == 1
        @select[i].render
      end
    end
  end

  #タイトル画面の諸々の定義　↑ここまで↑

  #ファイルを,区切りで読み込んで配列として格納
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
  
  #n×mの多次元配列を生成し、vで要素を埋める
  def nm_array(n=1, m=1, v=nil)  
    (1..n).map {Array.new(m){v}}
  end
  
  ##########################################　プログレスバー　###################################################
  
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
  def self.reset  #時間を初期化
    @start_time = Time.now
  end

  def self.get  #経過時間を得る
    return Time.now - @start_time
  end 
end

class Clear_Timer
  def self.reset  #時間を初期化
    @start_time = Time.now
  end

  def self.get  #経過時間を得る
    return Time.now - @start_time
  end 
end

class Anime_Timer
  def self.reset  #時間を初期化
    @start_time = Time.now
  end

  def self.get  #経過時間を得る
    return Time.now - @start_time
  end 
end
##################################################################
