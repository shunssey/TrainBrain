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
  #タイトル画面の諸々の定義　↓ここから↓
  def setting_init
    @setting_btn = Button.new(Window_w - 72, 0, 72, 36, "完了", 16, Dgray, White)
#=begin
    #敵に関わる所
    @monster_data = load_datafile("./lib/data/monster_data.txt")
    $trace_monster_number = @monster_data[0][0].to_i
    @number_monster = Fonts.new(50, 100, "モンスターの数", 28, Black)
    @goukei_monster = Fonts.new(50, 130, "合計", 28, Black)
    @monster_name = ["追跡","ランダム","待ち伏せ"]
    @monster_type = Array.new
    @monster_type_number = Array.new
    @monster_up_btn = Array.new
    @monster_down_btn = Array.new
    @monster_data[0][0]
    @kumiawase_number = "2"
    for i in 0..0
      #ボタンを作成する           @btn = Button.new(x, y, w, h, string, font_size, color, st_color, gr_color1, gr_color2)
      @monster_up_btn[i] = Button.new(300+150*i, 60, 100, 30, "▲", 24, Dgray, Black)
      @monster_down_btn[i] = Button.new(300+150*i, 150, 100, 30, "▲", 24, Dgray, Black)
      @monster_type[i] = Fonts.new(300+150*i, 30, "#{@monster_name[i]}", 28, Black)
      @monster_type_number[i] = Images.new(300+150*i, 90, 100, 60, "#{$trace_monster_number}", 32, White, Black) 
    end
#=end
#=begin
    #組み合わせに関わる所
    #@monster_data = load_datafile("./lib/data/monster_data.txt")
    @kumiawase_number = "2"
    $heart_number = 3 #
    @kumiawase_number = @kumiawase_number.to_i
    @kumiawase_font = Fonts.new(50, 300, "宝箱の数", 28, Black)
    @kumiawase_up = Button.new(300, 260, 100, 30, "▲", 24, Dgray, Black)
    @kumiawase_down = Button.new(300, 350, 100, 30, "▲", 24, Dgray, Black)
    @kumiawase_number_img = Images.new(300, 290, 100, 60, "#{@kumiawase_number}", 32, White, Black) 
    #漢字/ひらがなに関わる所
#=end
#=begin
    #ライフに関するところ
    #@life_number = Array.new
    @life_number = load_datafile("./lib/data/life_number.txt")
    $heart_number = @life_number[0][0].to_i
    @life_font = Fonts.new(450, 100, "ライフの数", 28, Black)
    @life_up = Button.new(700, 60, 100, 30, "▲", 24, Dgray, Black)
    @life_down = Button.new(700, 150, 100, 30, "▲", 24, Dgray, Black)
    @life_number_img = Images.new(700, 90, 100, 60, "#{$heart_number}", 32, White, Black)
    #漢字/ひらがなに関わる所
#=end
#=begin
    @moji_hyouki = Fonts.new(50, 500, "表記設定", 28, Black) #全部＋２００する
    @monster_type[i] = Fonts.new(300+150*i, 30, "#{@monster_name[i]}", 28, Black)
    @moji_kana_img = Images.new(300, 460, 100, 30, "ひらがな", 28, Cream, Black)
    @moji_kannji_img = Images.new(450, 460, 100, 30, "漢字", 28, Cream, Black)
    @moji_kana_btn = Button.new(300, 490, 100, 60, "●", 32, White, Black)
    @moji_kannji_btn = Button.new(450, 490, 100, 60, "", 32, White, Black) 
#=end
    #音に関わる所
#=begin
    @moji_oto = Fonts.new(50, 650, "音", 28, Black) #全部＋２００する
    @moji_on_img = Images.new(300, 610, 100, 30, "ＯＮ", 28, Cream, Black)
    @moji_off_img = Images.new(450, 610, 100, 30, "ＯＦＦ", 28, Cream, Black)
    $BGM_state = load_datafile("./lib/data/BGM_state.txt") #[0][0]にしないといけない
    if $BGM_state[0][0] == "ON"
      @moji_on_btn = Button.new(300, 640, 100, 60, "●", 32, White, Black)
      @moji_off_btn = Button.new(450, 640, 100, 60, "", 32, White, Black) 
    elsif $BGM_state[0][0] == "OFF"
      @moji_on_btn = Button.new(300, 640, 100, 60, "", 32, White, Black)
      @moji_off_btn = Button.new(450, 640, 100, 60, "●", 32, White, Black) 
    end
#=end
  end #init
  
  def setting_update
#=begin
    #敵に関わる所
    if @monster_up_btn[0].pushed? && $trace_monster_number <= 5
      $trace_monster_number += 1
      file = File.open("./lib/data/monster_data.txt","w+")
      file.puts("#{$trace_monster_number},")
      file.close
      @monster_type_number[0] = Images.new(300+150*0, 90, 100, 60, "#{$trace_monster_number}", 32, White, Black) 
    end
    
    if @monster_down_btn[0].pushed? && $trace_monster_number >= 2
      $trace_monster_number -= 1
      file = File.open("./lib/data/monster_data.txt","w+")
      file.puts("#{$trace_monster_number},")
      file.close
      @monster_type_number[0] = Images.new(300+150*0, 90, 100, 60, "#{$trace_monster_number}", 32, White, Black) 
    end
#=end
    #組み合わせに関わる所
=begin
    if @kumiawase_up.pushed? && @kumiawase_number != 5
      @kumiawase_number += 1
      @kumiawase_number_img = Images.new(300, 290, 100, 60, "#{@kumiawase_number}", 32, White, Black) 
    end
    
    if @kumiawase_down.pushed? && @kumiawase_number != 2
      @kumiawase_number -= 1
      @kumiawase_number_img = Images.new(300, 290, 100, 60, "#{@kumiawase_number}", 32, White, Black) 
    end
=end
=begin
    #漢字/ひらがなに関わる所
    if @moji_kana_btn.pushed?
      @moji_kana_btn = Button.new(300, 490, 100, 60, "●", 32, White, Black)
      @moji_kannji_btn = Button.new(450, 490, 100, 60, "", 32, White, Black) 
    end
    
    if @moji_kannji_btn.pushed?
      @moji_kana_btn = Button.new(300, 490, 100, 60, "", 32, White, Black)
      @moji_kannji_btn = Button.new(450, 490, 100, 60, "●", 32, White, Black) 
    end
=end
#=begin
    #ライフに関するところ
    #@life_number = Array.new
    #$heart_number = @life_number[0][0].to_i
    if @life_up.pushed? && $heart_number <= 4
      $heart_number += 1
      @life_number_img = Images.new(700, 90, 100, 60, "#{$heart_number}", 32, White, Black)
      file = File.open("./lib/data/life_number.txt","w+")
      file.printf("#{$heart_number}")
      file.close
    end
    
    if  @life_down.pushed? && $heart_number >= 2
      $heart_number -= 1
      @life_number_img = Images.new(700, 90, 100, 60, "#{$heart_number}", 32, White, Black)
      file = File.open("./lib/data/life_number.txt","w+")
      file.printf("#{$heart_number}")
      file.close
    end
    #漢字/ひらがなに関わる所
#=end
    #音に関わる所
=begin
    if @moji_on_btn.pushed?
      @moji_on_btn = Button.new(300, 640, 100, 60, "●", 32, White, Black)
      @moji_off_btn = Button.new(450, 640, 100, 60, "", 32, White, Black)
      file = File.open("./lib/data/BGM_state.txt","w+")
      file.printf("ON,")
      file.close
    end
    
    if @moji_off_btn.pushed?
      @moji_on_btn = Button.new(300, 640, 100, 60, "", 32, White, Black)
      @moji_off_btn = Button.new(450, 640, 100, 60, "●", 32, White, Black)
      file = File.open("./lib/data/BGM_state.txt","w+")
      file.printf("OFF,")
      file.close
    end
=end
    
    #その他
    if @setting_btn.pushed?
      self.next_scene = Title_Scene
    end
  end #update
  
  def setting_render
    @setting_btn.render
#=begin
    @number_monster.render
    for i in 0..0
      #ボタンを作成する           @btn = Button.new(x, y, w, h, string, font_size, color, st_color, gr_color1, gr_color2)
      @monster_up_btn[i].render
      @monster_down_btn[i].render
      @monster_type[i].render
      @monster_type_number[i].render
    end
#=end
    #組み合わせに関わる所
=begin
    @kumiawase_font.render
    @kumiawase_up.render
    @kumiawase_down.render
    @kumiawase_number_img.render
#=end
    #漢字/ひらがなに関わる所
#=begin
    @moji_hyouki.render
    @moji_kana_img.render
    @moji_kannji_img.render
    @moji_kana_btn.render
    @moji_kannji_btn.render
    #音に関わる所
#=begin
    @moji_oto.render
    @moji_on_img.render
    @moji_off_img.render
    @moji_on_btn.render
    @moji_off_btn.render
=end
#=begin
    #ライフに関するところ
    #@life_number = Array.new
    @life_font.render
    @life_up.render
    @life_down.render
    @life_number_img.render
    #漢字/ひらがなに関わる所
#=end
  end #render
end #scene
##################################################################
