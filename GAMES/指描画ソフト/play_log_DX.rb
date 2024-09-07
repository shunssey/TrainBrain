#!ruby -Ks

#exerbで固めたexeから起動するときカレントディレクトリをexeのパスにする
if defined?(ExerbRuntime)
  Dir.chdir(File.dirname(ExerbRuntime.filepath))
end
require "lib/get_log_file.rb"
require "lib/dx_button"
require "dxruby"
require "sdl"
require "vr/vruby"
require "fileutils"

class Play_drawing
  def initialize
     
     self.load_Config
     
     @state = "drawing"
     @play_btn = Button.new(" ",50,100)
     @play_btn.image = "image/play.jpg"
     @save_btn = Button.new("保存(s)",30,$frame[3]-70,100,40,25)
     #@save_btn.change_mode = false
     @exit_btn = Button.new("閉じる(Esc)",5,$frame[3]+20,150,40,25)
      Window.resize(200+$frame[2], 100+$frame[3]) #ウィンドウ・サイズの設定
      Window.caption = "指描画ソフト [再生]"
      Window.x ,Window.y = 10, 10 #ウィンドウの表示位置を設定
      Window.bgcolor = [255,210,210] #ウィンドウの背景色
     
     #キャンパスの作成
     @frame_canvas = Image.new(@size+10,@size+10,[0,0,0])
     @canvas = Image.new(@size,@size,[255,255,255])
     if @flag_sample == 1
       @canvas.drawFont(0,0, @q, @q_font, [200,200,200])
     end
     @alpha = Image.new(@size,@size,[255,255,255])
     @alpha.setColorKey([255,255,255])
     
     #表示するステータスの取得
     SDL.init(SDL::INIT_EVERYTHING)
     @time0 = SDL.getTicks/1000.0
     @font = Font.new(24, "桃花丸ゴシックL")
     #@font = Font.new(24)
     tmp = $filename.split("_")
     @file_st = tmp[1]
     @file_inf = tmp[4][0..1]+"/"+tmp[4][2..3]+"   "+tmp[5][0..1]+":"+tmp[5][2..3]
     w = @data[@data.size-1][2].to_i.to_s.size #整数部分の桁数を取得
     @file_time = @data[@data.size-1][2][0..w+2]
     if tmp[4][0..1].to_i < 7
       $minus_flag = false
     elsif tmp[4][0..1].to_i < 12
       $minus_flag = true #点の描画位置の修正を行うフラグ
       @size_pen = 10
     elsif tmp[4][0..1].to_i == 12 and tmp[4][2..3].to_i <= 2
       $minus_flag = true
       @size_pen = 10
     end
     #self.make_bar
  end
  
  def load_Config
     file = open($filename,"r")
     @data = file.readlines
     file.close
     
     if @data.size < 20
       p "#{$filename}"
       p "    >> ファイルが小さすぎます。"
       SWin::Application.messageBox("再生できません。\n(ファイルが小さすぎます)","Error",0)
       exit #メソッドの終了
     else
       for i in 0 .. @data.size-1
         @data[i] = @data[i].chomp.split(",")
       end
     end
    
     #座標設定の読み込み
     if @data[0].include?("frame")
       tmp = @data[0]
       $frame = [tmp[1].to_i, tmp[2].to_i, tmp[3].to_i, tmp[4].to_i]
       @data.delete_at(0)
     else
       $frame = [250,100,550,550]
     end
     @size = $frame[2]
     #フォントの読み込み
     Font.install("./lib/brtoulw0.ttf") # 桃花丸ゴシック
     if @data[0].include?("font")
       @q_font = Font.new(@size, @data[0][1])
       @data.delete_at(0)
     else
       #@q_font = Font.new(@size, "桃花丸ゴシックL")
       @q_font = Font.new(@size, "EPSON 教科書体Ｍ")
     end
     #ペンの太さの読み込み
     if @data[0].include?("pen")
       @size_pen = @data[0][1].to_i
       @data.delete_at(0)
     else
       @size_pen = 15
     end
     #見本の設定読み込み
     if $filename.include?("見本なし")
       @flag_sample = 0
     else
       @flag_sample = 1
       @q = $filename.split("_")[1]
     end
  end
  
  def make_bar
    @bar_x = 420
    @bar_y = 10
    @bar = Image.new(200,40,[255,255,255])
    @bar.setColorKey([255,255,255])
    @bar.line(0,20,200,20,[0,0,0])
    for i in 0 ... 10
      if i == 0 or i == 5
        @bar.line(20*i,5,20*i,35,[0,0,0])
      else
        @bar.line(20*i,10,20*i,30,[0,0,0])
      end
    end
    @bar.line(199,5,199,35,[0,0,0])
    @bb = Image.new(5,20,[150,150,150])
    @bb_y = @bar_y + @bar.height/2 - 10
  end
  
  def draw_circle(x,y)
    @alpha.circleFill(x,y, @size_pen, [0,0,0])
  end
  
  def draw_alpha(x,y)
    @alpha.circleFill(x,y, @size_pen, [255,0,0])
    @alpha.setColorKey([255,0,0])
  end
  
  def draw_init
    @alpha.fill([255,255,255])
    @alpha.setColorKey([255,255,255])
  end
  
  def change_PlayMode
    if @state == "drawing"
      @state = "stop"
      @play_btn.image = "image/stop.jpg"
      @stop_start = SDL.getTicks/1000.0
      @play_btn.render
    elsif @state == "stop"
      @state = "drawing"
      @play_btn.image = "image/play.jpg"
      @stop_time += SDL.getTicks/1000.0 - @stop_start
      @play_btn.render
    end
  end
  
  def draw_Screen
    @play_btn.render
    @save_btn.render
    @exit_btn.render
    Window.drawFont(20,10, "文字:#{@file_st}   日時:#{@file_inf}", @font, :color=>[0,0,0])
    Window.drawFont(20,40, "総再生時間:#{@file_time}[s]", @font, :color=>[0,0,0])
    Window.drawFont(20,200, "再生時間:", @font, :color=>[0,0,0])
    w = @now_time.to_i.to_s.size #整数部分の桁数を取得
    Window.drawFont(20,230, "  #{@now_time.to_s[0..w+2]}[s]", @font, :color=>[0,0,0])
    #Window.draw(@bar_x,@bar_y,@bar)
    #x = @bar_x + @bar.width*(@now_time.to_f / @file_time.to_f) #バーの現在値を算出
    #Window.draw(x,@bb_y,@bb)
    Window.draw(165,65,@frame_canvas)
    Window.draw(170,70,@canvas)
    Window.draw(170,70,@alpha)
  end
  
  def loop
   #p "return"
   #return
   
   n = 0
   @stop_time = 0
   Window.loop do
     #図形の描画
     if @state == "drawing"
       @now_time = SDL.getTicks/1000.0 - @time0 - @stop_time
       if @now_time > @data[n][2].to_i
         if @data[n][0] == "init"
         #全消去
           self.draw_init
         else
         #点を描画
           if $minus_flag #座標の修正を行うためのフラグ
             x, y = @data[n][0].to_i - $frame[0], @data[n][1].to_i - $frame[1]
           else
             x, y = @data[n][0].to_i, @data[n][1].to_i
           end
           if @data[n][3] == "white"
             #消去
             self.draw_alpha(x,y)
           elsif @data[n][3] == "black"
             #書き込み
             self.draw_circle(x,y)
           end
         end
         n += 1
         if n >= @data.size #終了処理
           p @state = "finish"
           @play_btn.image = "image/finish.png"
           #@save_btn.change_mode = true
         end
       end
       self.draw_Screen
     end #time
     
     #ボタンの処理
     if Input.mousePush?(M_LBUTTON)
       x, y = Input.mousePosX, Input.mousePosY
       if @save_btn.pushed?(x,y)
       #保存ボタン
          #if @state == "finish"
            self.save_image
            exit
          #end
       elsif @exit_btn.pushed?(x,y)
       #閉じるボタン
          exit
       #elsif (0..@bar.width).include?(x-@bar_x) and (0..@bar.height).include?(y-@bar_y)
       #再生のシークバー
       #   rate = (x-@bar_x)/@bar.width.to_f
       #   n = (@data.size * rate).to_i
       #   
       else
          #再生とストップの切り替え
          self.change_PlayMode
       end
     elsif Input.keyPush?(K_ESCAPE)
       #閉じるボタン
       exit
     elsif Input.keyPush?(K_S)
       #保存ボタン
          #if @state == "finish"
            self.save_image
            exit
          #end
     elsif Input.keyPush?(K_RETURN)
       self.change_PlayMode
     end
   end #looop
  end
    
  def save_image
    @frame_canvas.draw(5,5,@canvas)
    @frame_canvas.draw(5,5,@alpha)
    
    name = File.basename($filename,".*")
    @frame_canvas.save("out/#{name}.png",FORMAT_BMP)
    p "OK => #{name}.png"
  end

end

##### 読み込むlogファイルの決定 #####
  
  VRLocalScreen.modalform(nil,nil,MyForm)
  VRLocalScreen.messageloop
  
  #dir = Dir.pwd
  #$filename = Window.openFilename([["CSVファイル","*.csv"],["すべてのファイル","*.*"]],"test")
  #Dir.chdir(dir)
  
  
  if $filename == nil
    p "Please select log-file."
    exit
  end
  
#####################################


##### 描画記録の再生 #####
  
  play = Play_drawing.new
  play.loop
  
#####################################
