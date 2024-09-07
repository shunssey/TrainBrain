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
require 'lib/image.rb'
######################################################
Black = [0, 0, 0,]
White = [255, 255, 255]
Green = [0, 255, 0]
Blue = [0, 0, 255]
Red = [255, 0, 0]
Orange = [255, 255, 0]
Gray = [220, 220, 220]
Dgray=[120,120,120]
######################################################
Window_w = 1024
Window_h = 768
Window.width  = Window_w
Window.height = Window_h
Window.bgcolor = Gray
Window.x = 0
Window.y = 0
#Window.scale = 1.5
Window.caption = "文字つみき" 
Window.fps = 60
Window.frameskip = true
######################################################
#logディレクトリがなければ作成
if FileTest.exist?("log") == false
  Dir::mkdir("log")
end
######log########################################
def logfile_open(string)
  date = Time.now.strftime("%Y.%m.%d_%H.%M.%S")
  fname = "log/#{string}_#{date}.csv"
  $file = File::open(fname, "w")
  $file.puts "設定,種類,呈示順"
end
logfile_open("文字つみき") 
#######################################################
class S_Timer
  def self.reset  #時間を初期化
    @start_time = Time.now
  end

  def self.get  #経過時間を得る
    return Time.now - @start_time
  end 
end
class S_Timer2
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
    @btn_mode=Array.new()
    @btn_mode[0] = Button.new(400, 460, "そのまま",36,144,72,Green)
    @btn_mode[1] = Button.new(400, 550, "さかさま",36,144,72,Dgray)
    @btn_mode[2] = Button.new(400, 640, "ランダム",36,144,72,Dgray)
    @mode_font = Fonts.new("もじのじゅんばん",340,410,30)
    #@btn_present=Array.new()
    #@btn_present[0] = Button.new(80, 460, "がぞう",36,144,72,Green)
    #@btn_present[1] = Button.new(80, 550, "もじ",36,144,72,Dgray)
    @btn_moji=Array.new()
    @btn_moji[0] = Button.new(80, 460, "せいおん",36,144,72,Green)
    @btn_moji[1] = Button.new(80, 550, "そくおん",36,144,72,Dgray)
    @btn_moji[2] = Button.new(80, 640, "ようおん",36,144,72,Dgray)
    @present_font = Fonts.new("もんだい",80,410,30)
    @btn_start = Button.new(750,550, "はじめる",36,144,72)
    @btn_full = Button.new(Window_w-72*2, 0, "full/win", 16,72,36)
    @btn_esc = Button.new(Window_w-72, 0, "おわり", 16,72,36)
    @title = Fonts.new("文字つみき",0,180)
    @title.x =Window_w/2 - 35*(@title.string).size/2
    $count=0   #
    $mode=0    #
    @mode=0    #
    $present=0 #
    @moji=0    #
    $sound_back=Sound.new("sound/entertainer.mid")
    $sound_back.stop
    @monkey_line1=Images.new(290,0,Green,5,1024)
    @monkey_image=Images.new(290,460)
    @monkey_image.image="image/monkey.png"
    $kawa_ff=Array.new(6,1)
    #追加(拡張子対応のため)
    $imageName=Dir.glob("image/*")
    $imageName2=Dir.glob("image/*")
    #p $imageName
    for i in 0 .. $imageName.size-1
      for j in 0 .. 5#image/を削除
        $imageName[i].slice!(0)
      end
    end
    #p $imageName
    $name = $imageName.dup
    for i in 0 .. $name.size-1
      for j in 0 .. 3#image/を削除
        $name[i].slice!(-1)
      end
    end
    #p $name
    $name2 = Array.new().map{Array.new()}
    for i in 0 .. $name.size-1
      $name2[i] = ["#{$name[i].dup}"]
    end
    #p $name2
    $name3 = [[]]
    for i in 0 .. $name2.size-1
      #for j in 0 .. $name2[i].size-1
        $name3[i] = $name2[i][0].split("")
      #end
    end
    #str = "あいう"
    #p str.split("")
    #p $name3
  end

  def present_change#2つならこっちの方がいい
    if @btn_present[0].pushed?
      $present=0
      @btn_present[0].color(Green)
      @btn_present[1].color(Dgray)
      @monkey_line1.color(Green)
    elsif @btn_present[1].pushed?
      $present=1
      @btn_present[0].color(Dgray)
      @btn_present[1].color(Red)
      @monkey_line1.color(Red)
    end
  end
  
  def moji_change
    if @btn_moji[0].pushed?
      @moji=0
      @btn_moji[0].color(Green)
      @btn_moji[1].color(Dgray)
      @btn_moji[2].color(Dgray)
      @monkey_line1.color(Green)
    elsif @btn_moji[1].pushed?
      @moji = 1
      $mode=3
      @btn_moji[0].color(Dgray)
      @btn_moji[1].color(Red)
      @btn_moji[2].color(Dgray)
      @monkey_line1.color(Red)
    elsif @btn_moji[2].pushed?
      @moji = 2
      $mode=4
      @btn_moji[0].color(Dgray)
      @btn_moji[1].color(Dgray)
      @btn_moji[2].color(Blue)
      @monkey_line1.color(Blue)
    end
  end
  
  def mode_change#文字に変更？
    for i in 0..2
      if  @btn_mode[i].pushed?
        if @mode < i
          @monkey_image.y+=90*(i-@mode)
        elsif @mode > i
          @monkey_image.y-=90*(@mode-i)
        end
        $mode=i
        @mode=i
        for j in 0..2
          @btn_mode[j].color(Dgray)
        end
        @btn_mode[i].color(Green)
      end
    end
  end

  def update
  moji_change
    mode_change
    #present_change
    
    if @btn_start.pushed?
      @mode_type=["順唱","逆唱","ランダム"]
      @mode_type2=["清音","促音","拗音"]
      if $mode == 1 || $mode == 2
        $file.puts ",#{@mode_type2[@moji]},#{@mode_type[$mode]}"
      else
        $file.puts ",#{@mode_type2[@moji]},#{@mode_type[0]}"
      end
      self.next_scene = Game_Scene
    elsif @btn_full.pushed?
      if Window.windowed?
        Window.windowed = false
      else
        Window.windowed = true
      end
    elsif @btn_esc.pushed?
      exit
    end
  end

  def render
    #@present_font.render
    @monkey_line1.render
    @monkey_image.render
    
    @btn_start.render
    @btn_full.render
    @btn_esc.render
    @title.render
#=begin
    if @moji==0
      @mode_font.render
      @btn_mode.each do |i|
        i.render
      end
    end
    #@btn_present.each do |i|
    #  i.render
    #end
    @btn_moji.each do |i|
      i.render
    end
#=end
  end
end

class Game_Scene < Scene::Base
  def init
    @ending=0      #
    @end_set=0     #
    @end_time=0    #
    @monkey_flag=0 #
    @end_array=Array.new(14,0)
    @block_color_array=[Red,Green,Blue,Orange]#もっと入れた方がいい
    @btn_esc = Button.new(Window_w-72, 0, "おわり", 16,72,32)
    @btn_next = Button.new(0, 768-32, "もどる", 16,72,32)
    @math_canvas=Images.new(500,40,White,400,700)
    @math_canvas.grid_make(-4,4,-7,7,400,700)
    $sound_back.play
    #@flag_stop=:off
    question_make
    question_change
    @tokuten_box = Array.new(@question.size)
    @tokuten = Fonts.new("　",80,570,50,Red)
    @question_block=make_taju(@question.size-1)
    new_block
    monkey_make
    ending_make
    @plus=0
    @hint_mode=0
    
    @image_blackout=Image.new(1024,768,[100,0,0,0])
    @image_blackout_start=Array.new()
    @image_blackout_start[0]=Image.new(724,768,[100,0,0,0])
    @image_blackout_start[1]=Image.new(500,518,[100,0,0,0])
    
    @btn_start=Button.new(150,390,"かいし",32,144,54)
    @btn_stop = Button.new(0, 768-64, "とめる", 16,72,32)
    @time_stop=0
    #log
    
  end
  
  def tokuten_make
    s = 0
    m = 0
    for i in 0..@question.size-1
      if @tokuten_box[i] == 0 
        m += 1
      elsif @tokuten_box[i] == 1 
        s += 1
      end
    end
    if m + s == 0
      @tokuten = Fonts.new("　",80,30,50)
    else
      if s == 0
        @tokuten = Fonts.new("　",80,570,50,Red)
      else
        @tokuten = Fonts.new("点数:#{40+s*10}点",80,570,50,Red)
      end
    end
  end
  def question_change
    name=["ゃ","ゅ","ょ","っ"]
    @change=0
    @flag=0
    #p @question
    @question_name=Marshal.load(Marshal.dump(@question[$count]))
    #p @question_name
    for i in 0..@question_name.size-1
      if @question_name[i]=="ゃ"or@question_name[i]=="ゅ"or@question_name[i]=="ょ"or@question_name[i]=="っ"
        if i == 1
          @flag=1
        else
          @change=i
        end
      end
    end
    for i in 0..@question_name.size-1#2文字目に小さい文字が来るようにしているようだ
      for j in 0..3
        if  @question_name[i]==name[j]
          tmp = @question_name[0]
          @question_name.delete("#{name[j]}")
          @question_name.delete_at(0)
          @question_name.unshift("#{tmp}","#{name[j]}")
        end
      end
    end
  end
  
  def monkey_make
    @monkey_line1=Images.new(400,@y_btom[@question.size-1],Blue,5,1024-@y_btom[@question.size-1])
    @monkey_line2=Images.new(300,@y_btom[@question.size-1],Blue,200,5)
    @monkey_image=Images.new(400,690)
    @monkey_image.image="image/monkey.png"
    @monkey_fun_image=Images.new(425,@y_btom[@question.size-1]-50)
    @monkey_fun_image.image="image/monkey_fun.png"
    @banana_image=Images.new(375,@y_btom[@question.size-1]-50)
    @banana_image.image="image/banana.png"
    @font_line1 = Fonts.new("ここまで",170,@y_btom[@question.size-1]-15,30)
    @font_line2 = Fonts.new("がんばって",160,@y_btom[@question.size-1]+15,30)
  end
  
  def monkey_judge
    @monkey_image.y-=50
  end
  
  def monkey_move
    if @monkey_fun_image.x>=-60
      @monkey_fun_image.x-=5
      @banana_image.x-=5
    end
  end
  
  def make_taju(n)
    (0..n).map{Array.new(0)}
  end
  
  def question_make
    @y_btom=[690,640,590,540,490,440,390,340,290,240,190,140,90,40]
    @x_pos= [500,550,600,650,700,750,800,850,900,950]
    if $mode == 0
      @question=load_datafile("question/せいおん_正順.txt")
      @gazo=load_datafile("question/せいおん_正順.txt")
    elsif $mode==1
      @question=load_datafile("question/せいおん_逆順.txt")
      @gazo=load_datafile("question/せいおん_逆順.txt")
    elsif $mode==2
      @question=load_datafile("question/せいおん_ランダム.txt")
      @gazo=load_datafile("question/せいおん_ランダム.txt")
    elsif $mode == 3
      @question=load_datafile("question/そくおん.txt")
      @gazo=load_datafile("question/そくおん.txt")
    else
      @question=load_datafile("question/ようおん.txt")
      @gazo=load_datafile("question/ようおん.txt")
    end
    @block_pos=rand(8-@question[$count].size)
    @dark_block=make_taju(@question.size-1)
    @font=Fonts.new("をつくってね",100,340,32)
    @font_waku=Images.new(-3,40)
    @font_waku.image="image/ic_045A.png"
    @font_next=Fonts.new("つぎは",920,80,28)
  end

  def ending_play
    if @end_set==0
      @end_time=S_Timer.get
      @end_set=1
    end
    for i in 0..13
      if i*0.1 <= S_Timer.get-@end_time and S_Timer.get-@end_time<0.1*14
        @end_array[i]=1
      elsif i*0.1+1.5 <= S_Timer.get-@end_time
        @end_array[i]=0
      end
    end
    for i in 0..13
      for j in 0..7
        @ending_block[i][j].render if @end_array[i]==1
      end
    end
    @monkey_flag=2  if @end_array[13]==1
    @monkey_flag=3  if @end_array[13]==0 and @monkey_flag==2
  end
  
  def ending_make
    a=0
    @ending_block=make_taju(13)
    for i in 0..13
      for j in  0..7
        @ending_block[i][j]= Images.new(500+50*j,@y_btom[i],@block_color_array[i%4],50,50) 
        @ending_block[i][j].waku(Black)
      end
    end
  end

  def target_make1#視覚提示版
    @teiji_block=Array.new()
    for i in 0..@question[$count].size-1
      @teiji_block[i] = Images.new(70+50*i,245,Dgray,50,50,"#{@question[$count][i]}")
      @teiji_block[i].waku(Black)
    end
    S_Timer.reset
    @time_font = Fonts.new("けいかじかん　#{S_Timer.get.truncate}びょう",80,30,30)
    #@time_font = Fonts.new("けいかじかん",80,30,30)
  end

  def target_make0
    @teiji_image=Images.new(115,125)
    #p $name3
    #p @gazo
    for i in 0 .. $imageName.size-1
      if $name3[i] == @gazo[$count]
        @teiji_image.image="#{$imageName2[i]}"
      else
        #@teiji_image.image="image/#{$imageName[i]}"#はてな画像
      end
    end
    #@teiji_image.image="image/#{@gazo[$count]}.jpg"
    @sx=200.0/@teiji_image.w
    @sy=200.0/@teiji_image.h
    S_Timer.reset
    @time_font = Fonts.new("けいかじかん　#{S_Timer.get.truncate}びょう",80,15,30)
    #@time_font = Fonts.new("けいかじかん",80,15,30)
  end
  
  def new_block#次の問題
    
    if $present==0
      target_make0
    else
      target_make1
    end
    @block_pos=rand(8-@question[$count].size)
    if $mode==0 || $mode==3 || $mode==4
      @first_block=0#固定ブロック
    elsif $mode==1
      @first_block=@question[$count].size-1#固定ブロック
    else
      @first_block=rand(@question[$count].size)#固定ブロック
    end
    @down_block=Array.new()
    for i in 0..@question[$count].size-1
      @down_block[i]=i
    end
    @down_block.delete(@first_block)
    if $mode==0 || $mode==3 || $mode==4
      if @change==0
        @down_block=@down_block.sort_by{rand}#落とす順番をランダム
      else
        @down_block=@down_block.sort
      end
      @down_block=@down_block.sort  if @flag==1
      @down_block=@down_block.sort  if $mode==0
    elsif $mode==1
      @down_block=@down_block.reverse
    else
      @down_block=@down_block.sort_by{rand}#落とす順番をランダム
    end
    @point=@down_block[0]
    @correct_x=Array.new()#正解のx位置
    @down_block.delete(@point)
    for i in 0..@question[$count].size-1
      if $mode==1 
        @question_block[$count][i] = Images.new(500+50*@block_pos+50*i,-50,Dgray,50,50,"#{@question_name[i]}")#Images.new(500+50*@block_pos+50*(@question[$count].size-1-i),-50,Dgray,50,50,"#{@question_name[i]}")
        @correct_x[i]=500+50*@block_pos+50*i#(@question[$count].size-1-i)
      else
        @question_block[$count][i] = Images.new(500+50*@block_pos+50*i,-50,Dgray,50,50,"#{@question_name[i]}")
        @correct_x[i]=500+50*@block_pos+50*i
      end
      @question_block[$count][i].waku(Black)
    end
    #@question_block[$count][@first_block].x=500+50*@block_pos  
    @question_block[$count][@first_block].y=@y_btom[$count]
    for i in 0..13
      @dark_block[$count][i] = Images.new(500+50*i,@y_btom[$count],@block_color_array[i%4],50,50) 
      @dark_block[$count][i].waku(Black)
    end
    @dark_block[$count].slice!(@block_pos,@question[$count].size)
    @question_block[$count][@point].y = 40
    @question_block[$count][@point].x = @x_pos[rand(8)]
    next_think
    log_puts(0)
        if @change!=0
          for i in 0..@change-2
            tmp=@correct_x[i+1]
            @correct_x[i+1]=@correct_x[@change]
            @correct_x[@change]=tmp
          end
        end
    @visual_flag=0
    @flag_stop=:on_2
  end
  
  def next_think
    if @down_block[0]
      @next_point=@down_block[0]
      @next_block=Images.new(930,140,Dgray,50,50,"#{@question_name[@next_point]}")
      @next_block.waku(Black)
    else
      @next_point=nil
    end
  end
  
  def judgement#正解判定
    @judge_x=Array.new()
    for i in 0..@question[$count].size-1
      @judge_x[i]=@question_block[$count][i].x
    end
  end
  
  def load_datafile(filename)
    array = []
    open(filename) do |file|
      while l = file.gets
         array.push l.chomp.split(//s)
      end
    end
    return array
  end
  
  def block_move
    @question_block[$count][@point].y+=1
    if Input.keyPush?(K_RIGHT)
      log_puts(1)
      @question_block[$count][@point].x+=50 if  (500..800).include?(@question_block[$count][@point].x)
    end
    if Input.keyPush?(K_LEFT)
      log_puts(2)
      @question_block[$count][@point].x-=50 if  (550..850).include?(@question_block[$count][@point].x)
    end
    if Input.keyDown?(K_DOWN)
      log_puts(3)
      @question_block[$count][@point].y+=2 if  (50..@y_btom[$count]).include?(@question_block[$count][@point].y)
    end
  end
  
  def block_end
    if @question_block[$count][@point].y >= @y_btom[$count]#そこに着くと反応するよ
      @question_block[$count][@point].y =@y_btom[$count]#誤差修正
      $file.puts ",#{@question[$count]},#{@question_name[@point]},#{(@question_block[$count][@point].x-(500+50*@block_pos)+50)/50}文字目,#{S_Timer2.get}"
      if @down_block.size<1 #もう落とすものがない
        judgement
        if @judge_x==@correct_x#正解
          monkey_judge
          log_puts(4)
          @plus=0
          @tokuten_box[$count] = 1 if @tokuten_box[$count] == nil
          if $count != @question.size-1#最終問題以外
            $count+=1#次の階層へ
            question_change
            new_block#新しい階層作成
          else
            log_puts(99)
            @ending=1
            tokuten_make
            @monkey_flag=1
            #self.next_scene = Title_Scene
          end
        else#ハズレ
          $kawa_ff[$count]=0
          log_puts(5)
          @plus+=1
          @tokuten_box[$count] = 0
          new_block
        end
      else#まだ落とすよ
        @point=@down_block[0]
        @down_block.delete(@point)
        next_think
        @question_block[$count][@point].y = 40#適切な位置からスタート
        @question_block[$count][@point].x = @x_pos[rand(8)]
      end
    end
  end
  
    
  def log_puts(n)
    @mode_type=["順唱","逆唱","ランダム"]
    @present_type=["画像","文字"]
    @move_type=["Start","Right","Left","Down","Ok","Ng","Hint"]
    #$file.puts "呈示,モード,問題,選択,x,y,動作,時間,回数"
    case n
      when 0..3
        #$file.puts ",#{@mode_type[$mode]}"
      when 6
        #$file.puts ",#{@mode_type[$mode]}"
    end
  end

  def update
    if @btn_stop.pushed?#Input.keyPush?(K_S)#@btn_start.pushed?#
      if @flag_stop==:off
        @flag_stop=:on
        @btn_stop = Button.new(0, 768-64, "かいし", 16,72,32)
        #$sound_back.stop
        $file.puts "開始"
        #$file.printf("stop\n")
      else
        @flag_stop=:off
        @visual_flag=1
        @btn_stop = Button.new(0, 768-64, "とめる", 16,72,32)
        #$sound_back.play
        #$file.printf("restart\n")
        $file.puts "一時停止"
      end
    end
    
    if @btn_start.pushed?
      if @flag_stop==:on_2
        @flag_stop=:off
        @visual_flag=1
        $file.puts ""#改行
        $file.puts("第#{$count+1}問,問題,動かした文字,置いた場所,回答時間[s]")
        S_Timer2.reset
        #$file.puts ""
      end
    end
    if @btn_esc.pushed?
      exit 
      $file.puts "終了"
    end
    if @flag_stop==:off
      block_move if @ending==0
    else
    end
    block_end if @ending==0
    monkey_move if @monkey_flag==3
    if Input.keyPush?(K_N)
      self.next_scene = Title_Scene 
    end
    if @monkey_flag==3 and  @btn_next.pushed?
      self.next_scene = Title_Scene
    end
    if  Input.keyPush?(K_H)#ヒントモード
      log_puts(6)
      @hint_mode+=1 
    end
    if @hint_mode%2==1
      @question_block[$count][@point].x =@correct_x[@point]
    end
  end
  
  def render
    @btn_next.render  if @monkey_flag==3
    if @flag_stop==:off
      @time_font.string="けいかじかん　#{S_Timer.get.truncate}びょう"
    else
      
    end
    @time_font.render
    @font_line1.render
    @font_line2.render
    @monkey_line1.render
    @monkey_line2.render
    if @monkey_flag==0
      @monkey_image.render
    elsif @monkey_flag>=1
      @monkey_fun_image.render
    end
    @banana_image.render
    @btn_esc.render
    @math_canvas.render
    @font_waku.scale_render(1.55,1.55)
    @font.render
    for i in 0..$count
      for j in  0..(8-@question[i].size-1)
        @dark_block[i][j].render  if @visual_flag==1
      end
    end
    for i in 0..$count
      for j in  0..@question_block[i].size-1
        @question_block[i][j].render  if @visual_flag==1
      end
    end
    
    if  $present==0
      @teiji_image.scale_render(@sx,@sy)
    else
      @teiji_block.each do |i|#視覚提示版
        i.render
      end
    end
    
    if @ending==1
      ending_play
      @flag_stop = :on
      #@tokuten.render
    end
    if @next_point
      @font_next.render if @visual_flag==1
      @next_block.render if @visual_flag==1
    end
    
    if @flag_stop==:on
      @btn_stop.render
      Window.draw(0,0,@image_blackout) 
    elsif @flag_stop==:on_2
      Window.draw(500,0,@image_blackout_start[0]) 
      Window.draw(0,450,@image_blackout_start[1]) 
      @btn_start.render
    else
      @btn_stop.render
    end
  end
end
########################################################
########################################################
Scene.main_loop Title_Scene
