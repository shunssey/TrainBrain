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

class Init_Scene  < Scene::Base
  #タイトル画面の諸々の定義　↓ここから↓
  def stage_select_init
    @message_img = Images.new(50, 10, 500, 50, "ステージをえらぼう！", 40, White, White) #ステージの選択
    @message_img.image("./image/frame/frame.png")
    @message_img.font_color(White)
    @btn = Array.new
    $map = ["forest","cave","grassland","desert","ice","sea","swamp","snow","castle","volcano","eureka","machine"]
    $map_name = ["forest","cave","grassland","desert","ice","sea","swamp","snow","castle","volcano","eureka","machine"]
    @BG = Images.new(0,0,Window_w,Window_h)
    @BG.image("./image/world_map.png")
    @stage_info = load_datafile("./lib/data/stage_info.txt")
    @stage_info_img = Images.new(550, 575, 400, 150, "", 32, Blue, Black)
    @stage_info_img.image("./image/frame5.png")
    @font = Fonts.new(560, 600, "#{@stage_info[0][0]}", 26, White)
    @font2 = Fonts.new(560, 630, "#{@stage_info[0][1]}", 26, White)
    @font3 = Fonts.new(560, 660, "#{@stage_info[0][2]}", 26, White)
    @btn_frame = Images.new(40,125,450,600,"", 32, Yellow, Black)
    @btn_frame.image("./image/frame6.png")
    @level_img = Array.new
    for i in 0..11
      @btn[i] = Button.new(125*(i%3)+150, 150 + 150*(i/3), 100,100, "#{i/3+1}-#{i%3+1}", 35, Dgray, Black)
      @btn[i].image("./image/button1.png")
      @btn[i].font_color(White)
      @level_img[i] = Fonts.new(50, 180 + 150*(i/2), "レベル", 26, White)
    end
    @btn[0].waku(Red,10)
    @stage_img = Images.new(550, 150, 400, 400, "", 32, Blue, Black)
    @stage_img.image("./image/stage_image/forest_stage.png")
    @stage_img.waku(White,5)
    @next_btn = Button.new(Window_w-150,Window_h-80,100,50,"", 35, Dgray, Black)
    @next_btn.image("./image/ok_button.png")
    $map_count = 0
    $takarabako_number = 1 #宝箱の呈示の数
    $stage_number = 1 #問題のレベル、宝箱の数を指す
    $stage_select = "forest"
    $bgm_stage = Bass.loadSample(BGM_forest)
  end #init
  
  def stage_select_update
    for i in 0..11
      if @btn[i].pushed?
        p $map_count = i
        $stage_number = i%3 + 1
        $takarabako_number = i/3 + 1
        @stage_img.image("./image/stage_image/#{$map[i]}_stage.png")
        @stage_img.waku(White,5)
        @font = Fonts.new(560, 600, "#{@stage_info[i][0]}", 26, White)
        @font2 = Fonts.new(560, 630, "#{@stage_info[i][1]}", 26, White)
        @font3 = Fonts.new(560, 660, "#{@stage_info[i][2]}", 26, White)
        for i in 0..11
          @btn[i] = Button.new(125*(i%3)+150, 150 + 150*(i/3), 100,100, "#{i/3+1}-#{i%3+1}", 35, Dgray, Black)
          @btn[i].image("./image/button1.png")
          @btn[i].font_color(White)
          @level_img[i] = Fonts.new(50, 180 + 150*(i/2), "レベル", 26, White)
        end
        p $stage_select = $map[$map_count]
        @btn[$map_count].waku(Red,10)
      end
    end
    
    if @next_btn.pushed?
      @bgm_stage_select.stop
      case $stage_select
        when "forest"
          $bgm_stage = Bass.loadSample(BGM_forest)
        when "cave"
          $bgm_stage = Bass.loadSample(BGM_cave)
        when "desert"
          $bgm_stage = Bass.loadSample(BGM_desert)
        when "ice"
          $bgm_stage = Bass.loadSample(BGM_ice)
        when "swamp"
          $bgm_stage = Bass.loadSample(BGM_swamp)
        when "snow"
          $bgm_stage = Bass.loadSample(BGM_snow)
        when "volcano"
          $bgm_stage = Bass.loadSample(BGM_volcano)
        when "eureka"
          $bgm_stage = Bass.loadSample(BGM_eureka)
        when "grassland"
          $bgm_stage = Bass.loadSample(BGM_grassland)
        when "sea"
          $bgm_stage = Bass.loadSample(BGM_sea)
        when "castle"
          $bgm_stage = Bass.loadSample(BGM_castle)
        when "machine"
          $bgm_stage = Bass.loadSample(BGM_machine)
        end
      self.next_scene = Show_Scene
    end
    
    if Input.keyPush?(K_B)
      self.next_scene = Title_Scene
    end
  end #update
  
  def stage_select_render
    @BG.render
    @btn_frame.render
    @message_img.render
    for i in 0..11
      @btn[i].render
      @level_img[i].render
    end
    @stage_info_img.render
    @font.render
    @font2.render
    @font3.render
    @stage_img.render
    @next_btn.render
  end #render
end #scene
##################################################################
