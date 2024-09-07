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
require 'lib/color.rb'
require"find"
######################################################
Window_w = 1024
Window_h = 768
Window.width  = Window_w
Window.height = Window_h
Window.bgcolor = White#Darkblue
Window.x = 0
Window.y = 0
Title="先読みハノイの塔"
#Window.scale = 1.5
Window.caption = "#{Title}" 
Window.frameskip = true

$soundPush = Sound.new("sound/push13.wav")    #プッシュ音　ちなみに始めに音を読み込むときには処理が重い
$soundMiss = Sound.new("sound/incorrect.wav")
$soundSword = Sound.new("sound/sword1.wav")
$soundSel = Sound.new("sound/click.wav")
$soundEnter = Sound.new("sound/se_maoudamashii_system49.wav")
$soundCancel = Sound.new("sound/se_maoudamashii_system25.wav")
$soundModoru = Sound.new("sound/se_maoudamashii_system24.wav")
$soundClear = Sound.new("sound/win.mid")
def logfolder_create
  l_date = Time.now.strftime("%Y.%m.%d")
  if FileTest.exist?("log") == false
    Dir::mkdir("log")
  end
  if FileTest.exist?("log/#{l_date}") == false
    Dir::mkdir("log/#{l_date}")
  end
end
def logfile_open(string,templete)
  l_date = Time.now.strftime("%Y.%m.%d")
  date = Time.now.strftime("%Y.%m.%d_%H.%M.%S")
  fname = "log/#{l_date}/#{string}_#{date}.csv"
  $file = File::open(fname, "w")
  $file.puts "#{templete}"
end
logfolder_create
logfile_open("#{Title}"," ")
$flagLevel=3
$file.puts"円盤の数,何手でクリア？,手数,円盤,時間,場所,時間,行動,時間"
#######################################################
class Title_Scene < Init_Scene
  def init
    init_btn_make
    init_num
    @btn_start = Button.new(Window_w/2+15, Window_h/2+320, "開始",30,200,60)
    @title = Fonts.new("#{Title}",0,50,72,Darkblue)
    @title.x =Window_w/2 - 35*(@title.string).size/2
    $count=0
    
    @imgRule=Images.new(0,150,[0,0,0,0],Window_w)
    @imgRule.image("image/Rule.png")
    @imgRule.x=Window_w/2-@imgRule.w/2
    
    @imgRule.waku(Gray)
    
    @imgSetsu=Images.new(240,Window_h/2+322,[0,0,0,0],240,56,"円盤の数　　　　　　 　",25)
    @imgSetsu.waku(Orange)
  end
  
  def init_num
    iti_x=240
    @img_num = Images.new(Window_w/2-iti_x/2,Window_h/2+325)
    @img_num.point_string(17,9,"#{$flagLevel}",Black)
    level = %w[← →]
    @btn_level = Array.new()
    for i in 0 .. 1
      @btn_level[i] = Button.new(Window_w/2-iti_x/2 - 30 + 80*i,Window_h/2+325,"#{level[i]}",26,30,50)
    end
  end
  
  def update_num
    for i in 0 .. 1
      if @btn_level[i].pushed?
        $soundPush.play
        if i == 1 and $flagLevel != 5
          $flagLevel += 1
        elsif i == 0 and $flagLevel != 3
          $flagLevel -= 1
        end
        @img_num.box_fill(0, 0, 50,50, White)
        @img_num.point_string(17,9,"#{$flagLevel}",Black)
      end
    end
  end
  
  def render_num
    @img_num.render
    @btn_level.each do |i|
      i.render
    end
  end
  
  def update
    init_btn_update
    update_num
    @imgSetsu.render
    if @btn_start.pushed?
      $soundPush.play
      $numDisk=$flagLevel
      self.next_scene = Execution_Scene
    end
  end

  def render
    @imgRule.render
    init_btn_render
    render_num
    @btn_start.render
    @title.render
  end
end

class Execution_Scene < Init_Scene
  def init
    #init_btn_make
    @flagScene=0
    @flagGO=0
    S_Timer.reset
    
    @imgNum=Array.new()
    @btnSelPosi=Array.new()
    @stringPosi=%w[① ② ③]
    @arrPosiJudge=(0..2).map{Array.new()}
    for i in 0..2
      @imgNum[i]=Images.new((Window_w/4)*(i+1)-30,630,White,60,50,"#{i+1}",40)
      @imgNum[i].waku(Gray)
      @btnSelPosi[i]=Button.new(Window_w/2+80*i, 690, "#{@stringPosi[i]}",40,70,70)
      #for j in 0..$flagLevel-1
      #  if i==0
      #    @arrPosiJudge[i][j]=$flagLevel-1-j
      #  end
      #end
    end
    
    @flagStatus=0
    @arrPosiJudge=load_datafile_integer("quest/#{$flagLevel}.txt")
    for i in 0..@arrPosiJudge.size-1
      for j in 0..@arrPosiJudge[i].size-1
        @flagStatus+=1
      end
    end
    @arrPosiJudge.push([])
    @arrPosiJudge.push([])
    @btnDisk=Array.new()#将来の拡張のため一応btnで作っとく
    @btnSelDisk=Array.new()
    @stringDisk=%w[赤 橙 黄 緑 青 紫]
    
    for i in 0..@flagStatus-1
      for j in 0..2
        for k in 0..@arrPosiJudge[j].size-1
          if i==@arrPosiJudge[j][k]
            @btnDisk[i]=Button.new(Window_w/2-100, 10, " ",10,10,10)
            @btnDisk[i].image("image/disk#{i}.png")
            @btnDisk[i].x=(Window_w/4)*(j+1)-@btnDisk[i].w/2
            @btnDisk[i].y=580-48*k#580-53*(@arrPosiJudge[@arrLookAheadBox[@flagGO][1]].size-1)
          end
        end
      end
      @btnSelDisk[i]=Button.new(20+80*i, 690, "#{@stringDisk[i]}",40,70,70)
      if i==0
        @btnSelDisk[i].color(Red)
      elsif i==1
        @btnSelDisk[i].color(Orange)
      elsif i==2
        @btnSelDisk[i].color(Yellow)
      elsif i==3
        @btnSelDisk[i].color(Green)
      elsif i==4
        @btnSelDisk[i].color(Blue)
      elsif i==5
        @btnSelDisk[i].color(Purple)
      end
    end
    
    for i in 0..2
      @arrPosiJudge[i].unshift(100)
    end
    @arrLookAheadBox=Array.new()
    @arrLookAheadBoxTmp=Array.new()
    @imgLabel=Array.new()
    @imgLabelTmp=Images.new(10,10,Ivory,120,42," ",30)
    @imgLabelTmp.waku(Orange)
    @btnOK=Button.new((Window_w/4)*3, 690, "ＯＫ？",15,70,70)
    @btnCancel=Button.new((Window_w/4)*3+@btnOK.w, 690, "やり直す",15,70,70)
    @btnGO=Button.new(Window_w-100, 690, "動かす！",20,90,70)
    @btnBack=Button.new(Window_w-65, 5, "戻る",20,60,50)
    @btnKesu=Button.new(Window_w-65, 55, "消す",20,60,50)
    @btnHitotsuKesu=Button.new(Window_w-105, 105, "復活する",20,100,55)
    
    @imgTable=Images.new(10,580+28,White,150,40," ",30)
    @imgTable.image("image/table.png")
    @imgTable.x=Window_w/2-@imgTable.w/2
  end
  
  def update
    #init_btn_update
    if Input.keyPush?(K_B) or @btnBack.pushed?
      $soundPush.play
      $soundClear.stop
      self.next_scene = Title_Scene
    end
    if Input.keyPush?(K_ESCAPE)
      exit
    end
    if Input.keyPush?(K_N) or @btnKesu.pushed?
      $soundPush.play
      $soundClear.stop
      @flagStatus=0
      init
    end
    
    case @flagScene
    when 0
      for i in 0..@flagStatus-1
        if @btnSelDisk[i].pushed?
          @timeDisk=S_Timer.get
          $soundSel.play
          @arrLookAheadBoxTmp=[i,"　 "]
          #@imgLabelTmp.box_fill(1,1,@imgLabelTmp.w-2,@imgLabelTmp.h-2,White)
          @imgLabelTmp.string("#{@stringDisk[@arrLookAheadBoxTmp[0]]}　#{@arrLookAheadBoxTmp[1]}")
          @flagScene=1
        end
      end
      if @flagGO<@imgLabel.size
        if @btnGO.pushed?
          if @btnDisk[@arrLookAheadBox[@flagGO][0]].x==(Window_w/4)*1-@btnDisk[0].w/2
            @posiX=0
          elsif @btnDisk[@arrLookAheadBox[@flagGO][0]].x==(Window_w/4)*2-@btnDisk[0].w/2
            @posiX=1
          elsif @btnDisk[@arrLookAheadBox[@flagGO][0]].x==(Window_w/4)*3-@btnDisk[0].w/2
            @posiX=2
          end
          #その場で一番上にあるか＆#移動先の一番上より小さいか
          if (@arrLookAheadBox[@flagGO][0]==@arrPosiJudge[@posiX][@arrPosiJudge[@posiX].size-1])and(@arrLookAheadBox[@flagGO][0]<@arrPosiJudge[@arrLookAheadBox[@flagGO][1]][@arrPosiJudge[@arrLookAheadBox[@flagGO][1]].size-1])
            $file.puts",,,,,,,動かす○！,#{S_Timer.get}"
            $soundSword.play
            @moveX=((Window_w/4)*(@arrLookAheadBox[@flagGO][1]+1)-@btnDisk[0].w/2)-@btnDisk[@arrLookAheadBox[@flagGO][0]].x
            @moveY=580-48*(@arrPosiJudge[@arrLookAheadBox[@flagGO][1]].size-1)-@btnDisk[@arrLookAheadBox[@flagGO][0]].y
            @flagScene=3
            @flagAnime=0
            @imgLabel[@flagGO-1].waku(SukoshiDarkGray)# if 1<@flagGO
            @imgLabel[@flagGO].waku(Green)
          else
            $file.puts",,,,,,,動かす×！,#{S_Timer.get}"
            $soundMiss.play
            @imgLabel[@flagGO].waku(Red)
            @flagScene=4
          end
          #@btnDisk[@arrLookAheadBox[@flagGO][0]].x
          #@btnDisk[@arrLookAheadBox[@flagGO][0]].y
          #@flagGO+=1
        end
      end
      
    when 1
      for i in 0..2
        if @btnSelPosi[i].pushed?
          @timePosi=S_Timer.get
          $soundSel.play
          @arrLookAheadBoxTmp[1]=i
          @imgLabelTmp.box_fill(1,1,@imgLabelTmp.w-2,@imgLabelTmp.h-2,Ivory)
          @imgLabelTmp.string("#{@stringDisk[@arrLookAheadBoxTmp[0]]}　#{@stringPosi[@arrLookAheadBoxTmp[1]]}")
          @flagScene=2
        end
      end
      
    when 2
      if @btnOK.pushed?
        $file.puts"#{$numDisk},#{$flagLevel},#{@flagGO+1},#{@stringDisk[@arrLookAheadBoxTmp[0]]},#{@timeDisk},#{@stringPosi[@arrLookAheadBoxTmp[1]]},#{@timePosi},決定,#{S_Timer.get}"
        $soundEnter.play
        @arrLookAheadBox.push(@arrLookAheadBoxTmp)
        @imgLabel[@arrLookAheadBox.size-1]=Images.new(@imgLabelTmp.x, @imgLabelTmp.y,Ivory,120,42,"#{@stringDisk[@arrLookAheadBox[@arrLookAheadBox.size-1][0]]}　#{@stringPosi[@arrLookAheadBox[@arrLookAheadBox.size-1][1]]}",30)
        @imgLabel[@arrLookAheadBox.size-1].waku(SukoshiDarkGray)
        @arrLookAheadBoxTmp=Array.new()
        if (@arrLookAheadBox.size)%7==0# and (@arrLookAheadBox.size)!=0
          @imgLabelTmp.y=10
          @imgLabelTmp.x+=@imgLabelTmp.w+5
        else
          @imgLabelTmp.y+=@imgLabelTmp.h+5
        end
        @imgLabelTmp.box_fill(1,1,@imgLabelTmp.w-2,@imgLabelTmp.h-2,Ivory)
        @flagScene=0
        S_Timer.reset
      elsif @btnCancel.pushed?
        $file.puts"#{$numDisk},#{$flagLevel},#{@flagGO+1},#{@stringDisk[@arrLookAheadBoxTmp[0]]},#{@timeDisk},#{@stringPosi[@arrLookAheadBoxTmp[1]]},#{@timePosi},やり直し,#{S_Timer.get}"
        $soundCancel.play
        @arrLookAheadBoxTmp=Array.new()
        @imgLabelTmp.box_fill(1,1,@imgLabelTmp.w-2,@imgLabelTmp.h-2,Ivory)
        @flagScene=0
      end
    when 3
      if 0<=@flagAnime and @flagAnime<30
        @btnDisk[@arrLookAheadBox[@flagGO][0]].x+=@moveX/30
        @btnDisk[@arrLookAheadBox[@flagGO][0]].y+=@moveY/30
      else
        @btnDisk[@arrLookAheadBox[@flagGO][0]].x=((Window_w/4)*(@arrLookAheadBox[@flagGO][1]+1)-@btnDisk[0].w/2)
        @btnDisk[@arrLookAheadBox[@flagGO][0]].y=580-48*(@arrPosiJudge[@arrLookAheadBox[@flagGO][1]].size-1)
        @arrPosiJudge[@posiX].delete(@arrLookAheadBox[@flagGO][0])
        @arrPosiJudge[@arrLookAheadBox[@flagGO][1]].push(@arrLookAheadBox[@flagGO][0])
        if $flagLevel==3
          if @arrPosiJudge[2]==[100,2,1,0]
            $soundClear.play
            @flagScene=5
          end
        elsif $flagLevel==4
          if @arrPosiJudge[2]==[100,3,2,1,0]
            $soundClear.play
            @flagScene=5
          end
        elsif $flagLevel==5
          if @arrPosiJudge[2]==[100,4,3,2,1,0]
            $soundClear.play
            @flagScene=5
          end
        end
        @flagGO+=1
        @flagScene=0
        S_Timer.reset
      end
      @flagAnime+=1
      
    when 4
      if @btnHitotsuKesu.pushed?
        $file.puts",,,,,,,復活！,#{S_Timer.get}"
        $soundModoru.play
        modoru=0
        for i in 0..@arrLookAheadBox.size-1
          if @flagGO<=i
            @arrLookAheadBox.pop
            modoru+=1
          end
        end
        @imgLabelTmp.y=@imgLabelTmp.y-(@imgLabelTmp.h+5)*(modoru)
        @flagScene=0
        S_Timer.reset
      end
    when 5
    end
  end

  def render
    #init_btn_render
    @btnBack.render
    @btnKesu.render
    @imgTable.render
    for i in 0..@flagStatus-1
      @btnDisk[@flagStatus-1-i].render
    end
    for i in 0..2
      @imgNum[i].render
    end
    @imgLabelTmp.render
    if 1<=@arrLookAheadBox.size
      for i in 0..@arrLookAheadBox.size-1
        @imgLabel[i].render
      end
    end
    
    if 1<=@arrLookAheadBox.size and @flagGO<@imgLabel.size
      @btnGO.render
    end
    for i in 0..@flagStatus-1
      @btnSelDisk[i].render
    end
    for i in 0..2
      @btnSelPosi[i].render
    end
      
    case @flagScene
    when 0
    when 1
    when 2
      @btnOK.render
      @btnCancel.render
    when 3
    when 4
      @btnHitotsuKesu.render
    when 5
    end
  end
end

class End_Scene < Init_Scene
  def init
    init_btn_make
  end

  def update
    init_btn_update
  end

  def render
    init_btn_render
  end
end
########################################################
########################################################
Scene.main_loop Title_Scene
