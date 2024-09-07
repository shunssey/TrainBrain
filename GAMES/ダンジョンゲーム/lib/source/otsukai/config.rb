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
  def config_init
    @config_title = Images.new(Window_w/2-150, 0, 300, 100, "設定画面", 50, Cream, Black) 
    #単語数の定義
    $word_count = 1
    @word_countup_fonts = Fonts.new(50, 200, "・記憶単語数", 50, Black) 
    @word_countup = Images.new(350, 200, 100, 100, "#{$word_count}", 50, Cream, Black)
    @word_countup_button = Button.new( 350, 150, 100, 50, "▲", 50, Gray, Black)
    @word_countdown_button = Button.new( 350, 300, 100, 50, "▼", 50, Gray, Black)
    #店の数の定義
    $shop_count = 1
    @shop_countup_fonts = Fonts.new(50, 450, "・店の数", 50, Black) 
    @shop_countup = Images.new(350, 450, 100, 100, "#{$shop_count}", 50, Cream, Black)
    @shop_countup_button = Button.new( 350, 400, 100, 50, "▲", 50, Gray, Black)
    @shop_countdown_button = Button.new( 350, 550, 100, 50, "▼", 50, Gray, Black)
    #追加単語数の定義
    $word_addition_count = 0
    @word_addition_countup_fonts = Fonts.new(500, 200, "・追加単語回数", 50, Black) 
    @word_addition_countup = Images.new(850, 200, 100, 100, "#{$word_addition_count}", 50, Cream, Black)
    @word_addition_countup_button = Button.new( 850, 150, 100, 50, "▲", 50, Gray, Black)
    @word_addition_countdown_button = Button.new(850, 300, 100, 50, "▼", 50, Gray, Black)
    #削除単語数の定義
    $word_delete_count = 0
    @word_delete_countup_fonts = Fonts.new(500, 450, "・削除単語回数", 50, Black) 
    @word_delete_countup = Images.new(850, 450, 100, 100, "#{$word_delete_count}", 50, Cream, Black)
    @word_delete_countup_button = Button.new( 850, 400, 100, 50, "▲", 50, Gray, Black)
    @word_delete_countdown_button = Button.new(850, 550, 100, 50, "▼", 50, Gray, Black)
    #その他の定義
    @next_button = Button.new(Window_w-100, Window_h-100, 100, 100, "決定", 24, Gray, Black)
    @back_button = Button.new(0, Window_h-100, 100, 100, "戻る", 24, Gray, Black)
  end
  
  def config_update
    #p $word_count
    #単語数のカウント
    if @word_countup_button.pushed? && $word_count<= 8 #$word_countの制限
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
    
    #店のカウント
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
    
    #追加単語のカウント
    if @word_addition_countup_button.pushed? 
      $word_addition_count += 1
      @word_addition_countup = Images.new(850, 200, 100, 100, "#{$word_addition_count}", 50, Cream, Black)
    end
    
    if @word_addition_countdown_button.pushed? 
      $word_addition_count -= 1
      @word_addition_countup = Images.new(850, 200, 100, 100, "#{$word_addition_count}", 50, Cream, Black)
    end
    
    #削除単語のカウント
    if @word_delete_countup_button.pushed? 
      $word_delete_count += 1
      @word_delete_countup = Images.new(850, 450, 100, 100, "#{$word_delete_count}", 50, Cream, Black)
    end
    
    if @word_delete_countdown_button.pushed? 
      $word_delete_count -= 1
      @word_delete_countup = Images.new(850, 450, 100, 100, "#{$word_delete_count}", 50, Cream, Black)
    end
    
    #その他
    if @next_button.pushed?
      #self.next_scene = Main_Scene 
      self.next_scene = Main_Scene
    end
    
    if @back_button.pushed?
      self.next_scene = Title_Scene
    end
  end
  
  def config_render
    #単語数の定義
    @word_countup_fonts.render
    @word_countup.render
    @word_countup_button.render
    @word_countdown_button.render
    #お店の定義
    @shop_countup_fonts.render
    @shop_countup.render
    @shop_countup_button.render
    @shop_countdown_button.render
    #追加単語の定義
    @word_addition_countup_fonts.render
    @word_addition_countup.render
    @word_addition_countup_button.render
    @word_addition_countdown_button.render
    #削除単語の定義 $shop_count
    @word_delete_countup_fonts.render
    @word_delete_countup.render
    @word_delete_countup_button.render
    @word_delete_countdown_button.render
    #その他の定義
    @config_title.render
    @next_button.render
    @back_button.render
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
