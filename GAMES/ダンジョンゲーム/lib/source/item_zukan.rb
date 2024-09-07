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
##################################################################################################################################################################
#音楽に関わところ
#$select_SE = Sound.new("./lib/sound/select.wav")
#$ok_SE = Sound.new("./lib/sound/ok.wav")
#$cancel_SE = Sound.new("./lib/sound/cancel.wav")
##################################################################################################################################################################
class Init_Scene  < Scene::Base
  #タイトル画面の諸々の定義　↓ここから↓
  def item_zukan_init
    @setting_btn = Button.new(Window_w - 72, 0, 72, 36, "完了", 16, Dgray, White)
    @type_number = ["","1～8","9～16","17～24","25～32","33～40"]
    @type_number_count = 1
    @type_number_img = Images.new(0, 0, 200, 60, "No.#{@type_number[@type_number_count]}", 32, Cream, Black)
    @next_page_btn = Button.new(Window_w - 62, Window_h/2 - 50, 50, 100, "→", 32, Dgray, White)
    @back_page_btn = Button.new(12, Window_h/2 - 50, 50, 100, "←", 32, Dgray, White)
    #アイテムに関する所
    @item = (0..10).map{Array.new(10)}
    @item_info = load_datafile("./lib/data/item/item_data#{@type_number_count}.txt")
    @item_info[0][0]
    for j in 0..7
      @item[@type_number_count][j] = Images.new(88+220*(j%4), 64+340*(j/4), 200, 300, "", 32, Black, Black)
      if @item_info[0][j] == "ON"
        @item[@type_number_count][j].image("./lib/item/card/page_#{@type_number_count}/#{j+1}.png")
      end
    end
  end #init
  
  def item_zukan_update
    if @setting_btn.pushed? #設定ボタン タイトルに戻る
      self.next_scene = Title_Scene
    end
#ページを読み進めたところ
    if @next_page_btn.pushed? && @type_number_count != 5 || (Input.keyDown?(K_RIGHT) && @type_number_count != 5)
      $select_SE.play
      @type_number_count += 1
      @item_info = load_datafile("./lib/data/item/item_data#{@type_number_count}.txt")
      for j in 0..7
        @item[@type_number_count][j] = Images.new(88+220*(j%4), 64+340*(j/4), 200, 300, "", 32, Black, Black)
        if @item_info[0][j] == "ON"
          @item[@type_number_count][j].image("./lib/item/card/page_#{@type_number_count}/#{j+1}.png")
        end
      end
      @type_number_img = Images.new(0, 0, 200, 60, "No.#{@type_number[@type_number_count]}", 32, Cream, Black)
    end
    
#ページを戻したところ
    if @back_page_btn.pushed? && @type_number_count != 1 || (Input.keyDown?(K_LEFT) && @type_number_count != 1)
      $select_SE.play
      @type_number_count -= 1
      @item_info = load_datafile("./lib/data/item/item_data#{@type_number_count}.txt")
      for j in 0..7
        @item[@type_number_count][j] = Images.new(88+220*(j%4), 64+340*(j/4), 200, 300, "", 32, Black, Black)
        if @item_info[0][j] == "ON"
          @item[@type_number_count][j].image("./lib/item/card/page_#{@type_number_count}/#{j+1}.png")
        end
      end
      @type_number_img = Images.new(0, 0, 200, 60, "No.#{@type_number[@type_number_count]}", 32, Cream, Black)
    end
    
    if Input.mousePush?(M_RBUTTON)
      $cancel_SE.play
      self.next_scene = Title_Scene
    end
  end #update
  
  def item_zukan_render
    @setting_btn.render
    @type_number_img.render
    @next_page_btn.render
    @back_page_btn.render
    for j in 0..7
      @item[@type_number_count][j].render
    end
  end #render
end #scene
##################################################################
