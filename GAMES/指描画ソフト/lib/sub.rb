def screen_init(frame)
  #@canvas = SDL::Surface.new(SDL::SRCALPHA, @frame[2], @frame[3], 32, 0x000000ff, 0x0000ff00, 0x00ff0000, 0xff000000)
  #@canvas = SDL::Surface.load("image/canvas.png")
  #if @repeat - @n_repeat != 1
    @screen.fill_rect(@frame[0]-2,@frame[1]-2,@frame[2]+4,@frame[3]+4,[0,0,0])
    @screen.fill_rect(@frame[0],@frame[1],@frame[2],@frame[3],[255,255,255])
    @screen.put(@alpha,@frame[0],@frame[1]) if @sample == 1 # if @n_repeat <= @repeat - 2
  #else
  #  @screen.fill_rect(@frame[0]-@frame[2]/2-2,@frame[1]-2,@frame[2]+4,@frame[3]+4,[0,0,0])
  #  @screen.fill_rect(@frame[0]-@frame[2]/2,@frame[1],@frame[2],@frame[3],[255,255,255])
  #  @screen.put(@alpha,@frame[0]-@frame[2]/2,@frame[1]) if @n_repeat <= @repeat - 2
  #end
  #@screen.put(@canvas,@frame[0],@frame[1])
end

def flag_check(frame,x,y)
  @draw_flag = 0
  @draw = :not
  if (frame[0]..frame[0]+frame[2]).include?(x)
    if (frame[1]..frame[1]+frame[3]).include?(y)
       @draw_flag = 1
    end
  end
end

def screen_question
  @mode = :black
  @screen.fill_rect(0,0,SCREEN_W,SCREEN_H,BACK)
  #ボタンの描画
   @black.draw(@screen)
   @white.draw(@screen)
   @init.draw(@screen)
   @decide.draw(@screen)
   @full.draw(@screen)
  #ペイントのモードを描画
  @screen.fill_rect(@frame[0]-54,@frame[1],54,54,[0,0,0])
  @screen.put(@pen,@frame[0]-52,@frame[1]+2)
  #キャンバスを描画
  screen_init(@frame)
  #みほんを描画
  #if @repeat - @n_repeat != 1
  #  @screen.fill_rect(@frame[0]-@frame[2]-102,@frame[1]-2,@frame[2]+4,@frame[3]+4,[0,0,0])
  #  @screen.fill_rect(@frame[0]-@frame[2]-100,@frame[1],@frame[2],@frame[3],[255,255,255])
  #  @screen.put(@alpha_sample,@frame[0]-@frame[2]-100,@frame[1])
  #end
  #if @n_repeat <= @repeat - 2
  if @sample == 1
    @screen.put(@alpha,@frame[0],@frame[1])
  end
  @screen.update_rect(0,0,0,0)
  @first_time = SDL.getTicks/1000.0
end

def mk_question
  #path = "q/" + @q[@q_count] + ".png"
  #path2 = "q/" + @q[@q_count] + "_true.png"
  #path3 = "q/" + @q[@q_count] + "_sample.png"
  #@alpha = SDL::Surface.load(path)         #灰色、なぞる
  #@alpha_true = SDL::Surface.load(path2)   #赤
  #@alpha_sample = SDL::Surface.load(path3) #黒、見本
  
  @alpha = SDL::Surface.load("image/canvas2.png")
  @font_q.draw_solid_utf8(@alpha, NKF.nkf('-w',@q[@q_count]),0,0,200,200,200)
  @alpha_true = SDL::Surface.load("image/canvas2.png")
  @font_q.draw_solid_utf8(@alpha_true, NKF.nkf('-w',@q[@q_count]),0,0,255,0,0)
  #@alpha_sample = SDL::Surface.load("image/canvas2.png")
  #@font_q.draw_solid_utf8(@alpha_sample, NKF.nkf('-w',@q[@q_count]),0,0,0,0,0)
  
  time = Time.now
  date = time.strftime("%m%d_%H%M")
  if @n_repeat<10
    n = "0" + (@n_repeat+1).to_s
  else
    n = (@n_repeat+1).to_s
  end
  if @sample == 0
    number = n + "_見本なし"
  else
    number = n + "_見本あり"
  end
  $filename = "log/指描画_" + @q[@q_count] + "_" + number + "_" + date.to_s + "_" + ".csv"
  file = open($filename,"w")
  file.puts "frame,#{@frame[0]},#{@frame[1]},#{@frame[2]},#{@frame[3]}"
  file.close
end

def load_draw
  file = open($filename,"r")
  data = file.readlines
  file.close
  
  @canvas = SDL::Surface.load("image/canvas2.png")
  #@background = SDL::Surface.load("image/canvas.png")
  for i in 1..data.size-1
    st = data[i].chomp.split(",")
    if st[0] == "init"
      @canvas = SDL::Surface.load("image/canvas2.png")
    elsif st[3] == "not"
      x_before, y_before = :not, :not
    elsif st[3] == "black"
      x, y = st[0].to_i-@frame[0], st[1].to_i-@frame[1]
      x_before, y_before = x, y if x_before == :not
      @canvas.drawLine(x_before-1, y_before, x-1, y, [0,0,0])
      @canvas.drawLine(x_before, y_before, x, y, [0,0,0])
      @canvas.drawLine(x_before+1, y_before, x+1, y, [0,0,0])
      @canvas.drawLine(x_before, y_before-1, x, y-1, [0,0,0])
      @canvas.drawLine(x_before, y_before+1, x, y+1, [0,0,0])
      @canvas.drawLine(x_before-2, y_before, x-2, y, [0,0,0])
      @canvas.drawLine(x_before+2, y_before, x+2, y, [0,0,0])
      @canvas.drawLine(x_before, y_before-2, x, y-2, [0,0,0])
      @canvas.drawLine(x_before, y_before+2, x, y+2, [0,0,0])
      x_before, y_before = x, y
    elsif st[3] == "white"
      x, y = st[0].to_i-@frame[0], st[1].to_i-@frame[1]
      x_before, y_before = x, y if x_before == :not
      @canvas.drawLine(x_before-1, y_before, x-1, y, [255,255,255])
      @canvas.drawLine(x_before, y_before, x, y, [255,255,255])
      @canvas.drawLine(x_before+1, y_before, x+1, y, [255,255,255])
      @canvas.drawLine(x_before, y_before-1, x, y-1, [255,255,255])
      @canvas.drawLine(x_before, y_before+1, x, y+1, [255,255,255])
      @canvas.drawLine(x_before-2, y_before, x-2, y, [255,255,255])
      @canvas.drawLine(x_before+2, y_before, x+2, y, [255,255,255])
      @canvas.drawLine(x_before, y_before-2, x, y-2, [255,255,255])
      @canvas.drawLine(x_before, y_before+2, x, y+2, [255,255,255])
      x_before, y_before = x, y
    end
  end
end

def write_log(x,y,time,mode)
  time_now = Time.new.strftime("%H:%M:%S")
  log = "#{x},#{y},#{time},#{mode},#{time_now}"
  #p log
  file = open($filename,"a")
  file.puts log
  file.close
end

def write_init
  log = "init"
  #p log
  file = open($filename,"a")
  file.puts log
  file.close
end
