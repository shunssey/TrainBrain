#!ruby -Ks
#exerbで固めたexeから起動するときカレントディレクトリをexeのパスにする
if defined?(ExerbRuntime)
  Dir.chdir(File.dirname(ExerbRuntime.filepath))
end
####################################################
require 'dxruby'
require 'lib/scene.rb'
require 'lib/button.rb'
require 'lib/font.rb'
######################################################
Black = [0, 0, 0]
White = [255, 255, 255]
Green = [50, 255, 50]
Yellow = [255, 255, 0]
Red = [255, 50, 50]
Gray = [200, 200, 200]
Gray_back = [250, 250, 250]
Sky = [100, 100, 255]
Blue = [0, 150, 255]
Usui = [230, 230, 230,]
######################################################
Window_w = 1024 
Window_h = 768
Window.width  = Window_w 
Window.height = Window_h
Window.bgcolor = Gray_back
Window.caption = "stroop_integration"
Window.fps = 30
Window.frameskip = true
FPS = 60
$radian = Math::PI
$hyupa = Sound.new("sound/hyupa.wav")
$hazure = Sound.new("sound/hazure.wav")
$seikai = Sound.new("sound/seikai.wav")
$pin = Sound.new("sound/b_se1.wav")
#$image_back = Image.load("image/back.png")
#$image_maru = Image.load("image/maru2.png")
$play = 1
COUNT_Q = 10#全課題の統一問題数
#####################################################
def logfolder_create
  l_date = Time.now.strftime("%Y.%m.%d")
  if FileTest.exist?("log") == false
    Dir::mkdir("log")
  end
  if FileTest.exist?("log/#{l_date}") == false
    Dir::mkdir("log/#{l_date}")
  end
end
def logfile_open(string)
  l_date = Time.now.strftime("%Y.%m.%d")
  date = Time.now.strftime("%Y.%m.%d_%H.%M.%S")
  fname = "log/#{l_date}/#{string}_#{date}.csv"
  $file = File::open(fname, "w")
  #$file.puts "目的,モード,カード１,カード２,カード３,カード４,正解カード,正解不一致色,選択カード,正否,解答時間,理由解答時間"
  $file.puts " "
end
logfolder_create
logfile_open("stroop_integration")
####################################################
class S_Timer
  def self.reset  #時間を初期化
    $start_time = Time.now
  end

  def self.get  #経過時間を得る
    return Time.now - $start_time
  end
end
$pre_mode = 0
######################################################
class Title_Scene < Scene::Base
  def init
    @btn_start = Button.new(Window_w/2-230 + 144, 500, "決定",36,144,72)
    @btn_full = Button.new(Window_w-72*2, 0, "full/win", 16,72,36)
    @btn_esc = Button.new(Window_w-72, 0, "終了", 16,72,36)
    @title = Fonts.new("ストループ課題統合",150 ,150, 80)
    
    @btn_mode = Array.new(4)
    @btn_mode_sel = Array.new(4)
    $flag_mode = Array.new(4)
    $mode = %w[色ストループ カウンティングストループ 空間ストループ 形ストループ]
    for i in 0 .. 3
      @btn_mode[i] = Button.new(100 + 210 * i, 400, "#{$mode[i]}", 16, 200, 60)
      @btn_mode_sel[i] = Button.new(100 + 210 * i, 400, "#{$mode[i]}", 19, 200, 60,Red)
      if i == $pre_mode
        $flag_mode[i] = 1
      else
        $flag_mode[i] = 0
      end
    end
  end
  
  def update
    if @btn_full.pushed?
      if Window.windowed?
        Window.windowed = false
      else
        Window.windowed = true
      end
    elsif @btn_esc.pushed?
      exit
    elsif @btn_start.pushed?
      for i in 0 .. 3
        if $flag_mode[i] == 1
          $pre_mode = i
        end
      end
      $time_start = S_Timer.reset
      self.next_scene = Title_Scene_0 if $pre_mode == 0
      self.next_scene = Title_Scene_1 if $pre_mode == 1
      self.next_scene = Title_Scene_2 if $pre_mode == 2
      self.next_scene = Title_Scene_3 if $pre_mode == 3
    end
    for i in 0 .. 3
      if @btn_mode[i].pushed?
        $flag_mode[i] = 1
        for j in 0 .. 3
          if j != i
            $flag_mode[j] = 0
          end
        end
      end
    end
  end
  def render
    @title.render
    @btn_full.render
    @btn_esc.render
    @btn_start.render
    for i in 0 .. 3
      if $flag_mode[i] == 1
        @btn_mode_sel[i].render
      else
        @btn_mode[i].render
      end
    end
  end
end
####################################################################################################

####################################################
$pre_purpose = 1
$pre_mode = 0
######################################################
class Title_Scene_0 < Scene::Base
  def init
    $file.puts "色ストループ"
    $file.puts "目的,モード,カード１,カード２,カード３,カード４,正解カード,正解不一致色,選択カード,正否,解答時間,理由解答時間"
    @btn_back_title = Button.new(Window_w-72*2, 36, "初めに戻る", 16, 72*2, 36)
    @btn_start = Button.new(Window_w/2-230 + 144, 500, "開始",36,144,72)#Window_w/2-230 + 144, 500 + 100 * 0, "#{$start[i]}",36,144,72) if i == 1
    @btn_full = Button.new(Window_w-72*2, 0, "full/win", 16,72,36)
    @btn_esc = Button.new(Window_w-72, 0, "終了", 16,72,36)
    $score = 0
    $num_q = COUNT_Q#問題数
    $count = 0#Game_Sceneで何回目か
    
    $purpose = %w[検査 訓練]
    $flag_purpose = Array.new(2)
    @btn_purpose = Array.new(2)
    @btn_purpose_sel = Array.new(2)
    #for i in 0 .. 1
    #  @btn_purpose[i] = Button.new(300 + 210 * i, 200, "#{$purpose[i]}", 20, 200, 60)
    #  @btn_purpose_sel[i] = Button.new(300 + 210 * i, 200, "#{$purpose[i]}", 20, 200, 60,Red)
    #  if i == $pre_purpose
    #    $flag_purpose[i] = 1
    #  else
    #    $flag_purpose[i] = 0
    #  end
    #end
    
    @btn_mode = Array.new(3)
    @btn_mode_sel = Array.new(3)
    $flag_mode = Array.new(3)
    $mode = %w[2カード 3カード 4カード]
    for i in 0 .. 2
      @btn_mode[i] = Button.new(225 + 200 * i, 380, "#{$mode[i]}", 36, 144, 72)#225 + 200 * i, 380, "#{$mode[i]}",36,144,72)
      @btn_mode_sel[i] = Button.new(225 + 200 * i, 380, "#{$mode[i]}", 36, 144, 72,Red)
      if i == $pre_mode
        $flag_mode[i] = 1
      else
        $flag_mode[i] = 0
      end
    end
  end
  
  def update
    if @btn_full.pushed?
      if Window.windowed?
        Window.windowed = false
      else
        Window.windowed = true
      end
    elsif @btn_esc.pushed?
      exit
    elsif @btn_back_title.pushed?
      self.next_scene = Title_Scene
    elsif @btn_start.pushed?
      #for i in 0 .. 1
      #  if $flag_purpose[i] == 1
      #    $pre_purpose = i
      #  end
      #end
      for i in 0 .. 2
        if $flag_mode[i] == 1
          $pre_mode = i
          $num_kard = i + 1
        end
      end
      $time_start = S_Timer.reset
      self.next_scene = Game_Scene_0
    end
    #for i in 0 .. 1
    #  if @btn_purpose[i].pushed?
    #    $flag_purpose[i] = 1
    #    for j in 0 .. 1
    #      if j != i
    #        $flag_purpose[j] = 0
    #      end
    #    end
    #  end
    #end
    for i in 0 .. 2
      if @btn_mode[i].pushed?
        $flag_mode[i] = 1
        for j in 0 .. 2
          if j != i
            $flag_mode[j] = 0
          end
        end
      end
    end
  end
  def render
    @btn_back_title.render
    @btn_full.render
    @btn_esc.render
    @btn_start.render
    #for i in 0 .. 1
    #  if $flag_purpose[i] == 1
    #    @btn_purpose_sel[i].render
    #  else
    #    @btn_purpose[i].render
    #  end
    #end
    for i in 0 .. 2
      if $flag_mode[i] == 1
        @btn_mode_sel[i].render
      else
        @btn_mode[i].render
      end
    end
  end
end
####################################################################################################
class Game_Scene_0 < Scene::Base
  def init
    @btn_back = Button.new(Window_w-72, 0, "戻る", 16, 72, 36)
    @font_remainder = Fonts.new("残り#{$num_q - $count - 1}問",450 ,560, 30)
    @btn_next = Button.new(450, 610, "次へ", 40, 120, 50)
    @btn_next = Button.new(450, 610, "終わり", 40, 120, 50) if $count == COUNT_Q - 1
    @btn_judge = Button.new(450, 550, "判定", 40, 120, 50)
    @feed_back = %w[正解 不正解]
    @font_feed = Array.new(2)
    for i in 0 .. 1
      @font_feed[i] = Fonts.new("#{@feed_back[i]}",460 ,330, 30)
    end
    @flag_next = 0
    @flag_collect = 0
    @log_kard = %w[カード１ カード２ カード３ カード４]
    
    #ボタン生成
    @btn_select = Array.new(4)
    @btn_select_push = Array.new(4)
    @flag_select = Array.new(4)
    #文字生成
    @string = %w[白 赤 黄 緑 青]
    @color = [White, Red, Yellow, Green, Blue]
    
    
    @subject = Array.new(4)
    if $count == 0
      @subject_sort = [0, 1, 2, 3, 4]#.sort_by{rand}
      @mismatch = rand($num_kard + 1)
    else
      #色文字の位置
      begin
        @subject_sort = [0, 1, 2, 3, 4].sort_by{rand}
      end while @subject_sort[0] == $pre_subject_sort[0] or @subject_sort[1] == $pre_subject_sort[1] or @subject_sort[2] == $pre_subject_sort[2] or @subject_sort[3] == $pre_subject_sort[3] or @subject_sort[4] == $pre_subject_sort[4] or (@subject_sort[4] == 4 and (@subject_sort[0] == 3 or @subject_sort[1] == 3)) or (@subject_sort[4] == 3 and (@subject_sort[0] == 4 or @subject_sort[1] == 4))#[White, Red, Yellow, Green, Blue]
      #不一致カードの位置
      if $pre_mode != 0
        begin
          @mismatch = rand($num_kard + 1)
        end while @mismatch == $pre_mismatch or (@subject_sort[@mismatch] == 4 and @subject_sort[4] == 3) or (@subject_sort[@mismatch] == 3 and @subject_sort[4] == 4)
      end
    end
    #2カードのときのみ正解位置決めうち
    if $pre_mode == 0
      @mismatch = 0 if $count == 0
      @mismatch = 0 if $count == 1
      @mismatch = 1 if $count == 2
      @mismatch = 1 if $count == 3
      @mismatch = 0 if $count == 4
      @mismatch = 0 if $count == 5
      @mismatch = 1 if $count == 6
      @mismatch = 0 if $count == 7
      @mismatch = 1 if $count == 8
      @mismatch = 0 if $count == 9
    end
    for i in 0 .. $num_kard
      @btn_select_push[i] = Button.new(285 - 120 * $pre_mode + 235 * i, 225, "　", 40, 235, 235,Gray)
      @btn_select_push[i] = Button.new(245 - 120 * $pre_mode + 300 * i, 225, "　", 40, 235, 235,Gray) if $pre_mode == 0
      @flag_select[i] = 0
      if i == @mismatch
        @btn_select[i] = Button.new(290 - 120 * $pre_mode + 235 * i, 230, "#{@string[@subject_sort[i]]}", 150, 225, 225, Black,[150,150,150],[0,0,0],@color[@subject_sort[4]])
        @btn_select[i] = Button.new(250 - 120 * $pre_mode + 300 * i, 230, "#{@string[@subject_sort[i]]}", 150, 225, 225, Black,[150,150,150],[0,0,0],@color[@subject_sort[4]]) if $pre_mode == 0
      else
        @btn_select[i] = Button.new(290 - 120 * $pre_mode + 235 * i, 230, "#{@string[@subject_sort[i]]}", 150, 225, 225, Black,[150,150,150],[0,0,0],@color[@subject_sort[i]])
        @btn_select[i] = Button.new(250 - 120 * $pre_mode + 300 * i, 230, "#{@string[@subject_sort[i]]}", 150, 225, 225, Black,[150,150,150],[0,0,0],@color[@subject_sort[i]]) if $pre_mode == 0
      end
    end
    $pre_mismatch = @mismatch
    $pre_subject_sort = @subject_sort
  end
  
  def update
    if @btn_back.pushed?
      $file.puts "初めに戻った"
      self.next_scene = Title_Scene_0
    end
    
    if @flag_next == 0
      for i in 0 .. $num_kard
        if @btn_select[i].pushed?
          @flag_select[i] = 1
          @flag_next = 1
          @log_select = i
          $time_start = S_Timer.get
          $time_second = S_Timer.reset
          if i == @mismatch
            @flag_collect = 1
          else
            @flag_collect = 2
          end
        end
      end
      
    elsif @flag_next == 1
      #if Input.key_push?( K_RETURN )
      $time_second = S_Timer.get
      if @flag_collect == 1
        #$seikai.play if $pre_purpose == 1
        $score += 100 / $num_q
        $file.puts "#{$purpose[$pre_purpose]},#{$mode[$pre_mode]},#{@string[@subject_sort[0]]},#{@string[@subject_sort[1]]},,,#{@log_kard[@mismatch]},#{@string[@subject_sort[4]]},#{@log_kard[@log_select]},○,#{$time_start},#{$time_second}" if $flag_mode[0] == 1
        $file.puts "#{$purpose[$pre_purpose]},#{$mode[$pre_mode]},#{@string[@subject_sort[0]]},#{@string[@subject_sort[1]]},#{@string[@subject_sort[2]]},,#{@log_kard[@mismatch]},#{@string[@subject_sort[4]]},#{@log_kard[@log_select]},○,#{$time_start},#{$time_second}" if $flag_mode[1] == 1
        $file.puts "#{$purpose[$pre_purpose]},#{$mode[$pre_mode]},#{@string[@subject_sort[0]]},#{@string[@subject_sort[1]]},#{@string[@subject_sort[2]]},#{@string[@subject_sort[3]]},#{@log_kard[@mismatch]},#{@string[@subject_sort[4]]},#{@log_kard[@log_select]},○,#{$time_start},#{$time_second}" if $flag_mode[2] == 1
      elsif @flag_collect == 2
        #$hazure.play if $pre_purpose == 1
        $file.puts "#{$purpose[$pre_purpose]},#{$mode[$pre_mode]},#{@string[@subject_sort[0]]},#{@string[@subject_sort[1]]},,,#{@log_kard[@mismatch]},#{@string[@subject_sort[4]]},#{@log_kard[@log_select]},×,#{$time_start},#{$time_second}" if $flag_mode[0] == 1
        $file.puts "#{$purpose[$pre_purpose]},#{$mode[$pre_mode]},#{@string[@subject_sort[0]]},#{@string[@subject_sort[1]]},#{@string[@subject_sort[2]]},,#{@log_kard[@mismatch]},#{@string[@subject_sort[4]]},#{@log_kard[@log_select]},×,#{$time_start},#{$time_second}" if $flag_mode[1] == 1
        $file.puts "#{$purpose[$pre_purpose]},#{$mode[$pre_mode]},#{@string[@subject_sort[0]]},#{@string[@subject_sort[1]]},#{@string[@subject_sort[2]]},#{@string[@subject_sort[3]]},#{@log_kard[@mismatch]},#{@string[@subject_sort[4]]},#{@log_kard[@log_select]},×,#{$time_start},#{$time_second}" if $flag_mode[2] == 1
      end
      if $pre_purpose == 0
        @flag_next = 2
      elsif $pre_purpose == 1
        @flag_next = 3
      end
      
    elsif @flag_next == 3
      #if Input.key_push?( K_RETURN )
      if @btn_judge.pushed?
        if @flag_collect == 1
          $seikai.play if $pre_purpose == 1
        elsif @flag_collect == 2
          $hazure.play if $pre_purpose == 1
        end
        @flag_next = 2
      end
      
    elsif @flag_next == 2
      if @btn_next.pushed?
        #sleep(1)
        $count += 1
        if $count != $num_q
          $time_start = S_Timer.reset
          self.next_scene = Game_Scene_0
        else
          self.next_scene = End_Scene_0
        end
      end
    end
  end
  
  def render
    if @flag_next == 2
      @btn_next.render
      @font_remainder.render if $count != COUNT_Q - 1 and $count != COUNT_Q
      #@font_feed[@flag_collect - 1].render if $pre_purpose == 1
    elsif @flag_next == 3
      @btn_judge.render
    end
    if @flag_next != 0# or @flag_next == 1 or @flag_next == 3
      @btn_select_push[@log_select].render
    end
    for i in 0 .. $num_kard
      @btn_select[i].render# if @flag_select[i] == 1 and $pre_purpose == 1
    end
    @btn_back.render
  end
end
######################################################
class End_Scene_0 < Scene::Base
  def init
    @btn_return = Button.new(Window_w/2-72, Window_h/2+200, "戻る",36,144,72)
    @btn_esc = Button.new(Window_w-72, 0, "終了", 16,72,36)
    @font_end = Fonts.new("おつかれさまでした",100 ,180, 100)
    @font_score = Fonts.new("#{$score}点です",300 ,380, 100)
    $time = S_Timer.get
    #$file.puts ",,,,,,,,#{$time},得点,#{$score},,"
  end
  def update
    if @btn_return.pushed?
      $file.puts "初めに戻った"
      $file.puts " "
      self.next_scene = Title_Scene_0
    elsif @btn_esc.pushed?
      exit
    end
  end
  def render
    @btn_return.render
    @btn_esc.render
    @font_end.render
    @font_score.render
  end
end
####################################################################################################

####################################################
######################################################
$p = 0
$flag_previously = Array.new(3)
class Title_Scene_1 < Scene::Base
  def init
    $file.puts "カウンティングストループ"
    $file.puts "モード,不一致数値,不一致個数,一致数値,一致個数,不一致カード位置,正否,課題解答時間,選択理由解答時間"
    @btn_back_title = Button.new(Window_w-72*2, 36, "初めに戻る", 16, 72*2, 36)
    $start = %w[練習 開始]
    @btn_start = Array.new(2)
    for i in 0 .. 1
      @btn_start[i] = Button.new(Window_w/2-230 + 144, 500 + 100 * 0, "#{$start[i]}",36,144,72) if i == 1
      @btn_start[i] = Button.new(Window_w/2-230 + 144, 5500 + 100 * i, "#{$start[i]}",36,144,72) if i == 0
    end
    @btn_full = Button.new(Window_w-72*2, 0, "full/win", 16,72,36)
    @btn_esc = Button.new(Window_w-72, 0, "終了", 16,72,36)
    $score = 0
    $num_p = COUNT_Q
    $count = 0#Game_Sceneで何回目か
    $num_q =    [1,2,3,4,5,6,7,8,9,5].sort_by{rand}#下 右 上 左の課題が出る####################################################################################################
    $num_q_no = [1,2,3,4,5,6,7,8,9,5].sort_by{rand}#下 右 上 左の課題が出る####################################################################################################
    for i in 0 .. 9#i番目について調べる
      for j in  0 .. 9
        begin
          for j in  0 .. 9
            if $num_q[i] == $num_q_no[j] and i == j
              $num_q_no = [1,2,3,4,5,6,7,8,9,5].sort_by{rand}
            end
          end
        end while $num_q[i] == $num_q_no[j] and i == j
      end
    end
    
  end
  def update
    if @btn_full.pushed?
      if Window.windowed?
        Window.windowed = false
      else
        Window.windowed = true
      end
    elsif @btn_esc.pushed?
      exit
    elsif @btn_back_title.pushed?
      self.next_scene = Title_Scene
    end
    for i in 0 .. 1
      if @btn_start[i].pushed?
        $time_start = S_Timer.reset
        $time_saaaa = S_Timer.reset
        self.next_scene = Game_Scene_1
        if i == 0
          $num_p = 4
          $num_q =    [6, 5, 3,4]#.sort_by{rand}#下 右 上 左の課題が出る####################################################################################################
          $num_q_no = [5, 2, 7,2]#.sort_by{rand}#下 右 上 左の課題が出る####################################################################################################
    
          $flag_subject = 0
        elsif i == 1
          $flag_subject = 1
        end
      end
    end
  end
  def render
    @btn_back_title.render
    @btn_full.render
    @btn_esc.render
    #@title.render
    for i in 0 .. 1
      @btn_start[i].render
    end
  end
end
####################################################################################################
class Game_Scene_1 < Scene::Base
  def init
    @btn_back = Button.new(Window_w-72, 0, "戻る", 16, 72, 36)
    @font_remainder = Fonts.new("残り#{$num_p - $count - 1}問",450 ,560, 30)
    @flag_next = 0
    @btn_next = Button.new(450, 610, "次へ", 40, 120, 50)
    @btn_next = Button.new(450, 610, "終わり", 40, 120, 50) if $count == COUNT_Q - 1
    @btn_judge = Button.new(450, 550, "判定", 40, 120, 50)
    #posi_x = [0,1,2,3,4,5,6,7,8].sort_by{rand}
    #posi_y = [0,1,2,3,4,5,6,7,8].sort_by{rand}
    posi_x = [0,1,2,3,4,5,6].sort_by{rand}
    posi_y = [0,1,2,3,4,5,6].sort_by{rand}
    @posi = [0, 1] if $count == 0
    @posi = [1, 0] if $count == 1
    @posi = [0, 1] if $count == 2
    @posi = [0, 1] if $count == 3
    @posi = [1, 0] if $count == 4
    @posi = [1, 0] if $count == 5
    @posi = [0, 1] if $count == 6
    @posi = [1, 0] if $count == 7
    @posi = [0, 1] if $count == 8
    @posi = [1, 0] if $count == 9
    @posi_log = %w[左 右]
    @btn_click = Array.new(2)
    @sel_click = Array.new(2)
    @flag_next_push = 0
    for i in 0 .. 1
      @btn_click[i] = Button.new(400 * @posi[i] + 140, 150, "　", 80, 340, 340, White, gr_color = [0,0,0],cg_color = [0,0,0],mz_color=[0,0,0])
      @sel_click[i] = Button.new(400 * @posi[i] + 140 - 10, 150 - 10, "　", 80, 340 + 20, 340 + 20, Usui, gr_color = [0,0,0],cg_color = [0,0,0],mz_color=[0,0,0])
    end
    
    
    @font_subject = [[],[],[],[],[],[],[],[],[],[]]
    @rand = [[4,3,1,7,5,2,9,0,6,8],[6,7,3,2,9,0,8,4,5,1]]
    a = rand(2)
    @rand = @rand[a]
    k = 0
    for i in 0 .. 9
      if i == 1
        for j in 0 .. @rand[0]
          @font_subject[i][j] = Fonts.new("#{i}", 400 * @posi[0].to_i + 180 + 30 * posi_x[j].to_i, 170 + 30 * posi_y[j].to_i, 50) 
        end
      elsif i == 2
        for j in 0 .. @rand[1]
          @font_subject[i][j] = Fonts.new("#{i}", 400 * @posi[0].to_i + 180 + 30 * posi_x[j].to_i, 170 + 30 * posi_y[j].to_i, 50) 
        end
      elsif i == 3
        for j in 0 .. @rand[2]
          @font_subject[i][j] = Fonts.new("#{i}", 400 * @posi[0].to_i + 180 + 30 * posi_x[j].to_i, 170 + 30 * posi_y[j].to_i, 50) 
        end
      elsif i == 4
        for j in 0 .. @rand[3]
          @font_subject[i][j] = Fonts.new("#{i}", 400 * @posi[0].to_i + 180 + 30 * posi_x[j].to_i, 170 + 30 * posi_y[j].to_i, 50) 
        end
      elsif i == 5
        for j in 0 .. @rand[4]
          @font_subject[i][j] = Fonts.new("#{i}", 400 * @posi[0].to_i + 180 + 30 * posi_x[j].to_i, 170 + 30 * posi_y[j].to_i, 50) 
        end
      elsif i == 6
        for j in 0 .. @rand[5]
          @font_subject[i][j] = Fonts.new("#{i}", (400 * @posi[0].to_i) + 180 + (30 * posi_x[j].to_i), 170 + (30 * posi_y[j].to_i), 50) 
        end
      elsif i == 7
        for j in 0 .. @rand[6]
          @font_subject[i][j] = Fonts.new("#{i}", 400 * @posi[0].to_i + 180 + 30 * posi_x[j].to_i, 170 + 30 * posi_y[j].to_i, 50) 
        end
      elsif i == 8
        for j in 0 .. @rand[7]
          @font_subject[i][j] = Fonts.new("#{i}", (400 * @posi[0].to_i) + 180 + (30 * posi_x[j].to_i), 170 + (30 * posi_y[j].to_i), 50) 
        end
      elsif i == 9
        for j in 0 .. @rand[8]
          @font_subject[i][j] = Fonts.new("#{i}", 400 * @posi[0] + 180 + 30 * posi_x[j], 170 + 30 * posi_y[j], 50) 
        end
      end
      @font_setsumei11 = Fonts.new("数字の読み : #{$num_q[$count]}", 400 * @posi[0].to_i + 180, 500, 30) 
      @font_setsumei12 = Fonts.new("数字の個数 : #{@font_subject[$num_q[$count]].size}", 400 * @posi[0].to_i + 180, 550, 30) 
      @font_setsumei21 = Fonts.new("数字の読み : #{$num_q_no[$count]}", 400 * @posi[1].to_i + 180, 500, 30) 
      @font_setsumei22 = Fonts.new("数字の個数 : #{$num_q_no[$count]}", 400 * @posi[1].to_i + 180, 550, 30) 
      @flag_setsumei = 0
      @btn_setsumei = Button.new(Window_w-72*3, 0, "説明", 16, 72, 36)
      @flag_judge = 0
      @flag_collect = 0
    end
    
    
    @font_subject_no = [[],[],[],[],[],[],[],[],[],[]]
    for i in 0 .. 9
      if i == 1
        @font_subject_no[i][0] = Fonts.new("#{i}", 400 * @posi[1] + 180 + 30 * posi_x[0], 170 + 30 * posi_y[0], 50) 
      elsif i == 2
        for j in 0 .. 1
          @font_subject_no[i][j] = Fonts.new("#{i}", 400 * @posi[1] + 180 + 30 * posi_x[j], 170 + 30 * posi_y[j], 50) 
        end
      elsif i == 3
        for j in 0 .. 2
          @font_subject_no[i][j] = Fonts.new("#{i}", 400 * @posi[1] + 180 + 30 * posi_x[j], 170 + 30 * posi_y[j], 50) 
        end
      elsif i == 4
        for j in 0 .. 3
          @font_subject_no[i][j] = Fonts.new("#{i}", 400 * @posi[1] + 180 + 30 * posi_x[j], 170 + 30 * posi_y[j], 50) 
        end
      elsif i == 5
        for j in 0 .. 4
          @font_subject_no[i][j] = Fonts.new("#{i}", 400 * @posi[1] + 180 + 30 * posi_x[j], 170 + 30 * posi_y[j], 50) 
        end
      elsif i == 6
        for j in 0 .. 5
          @font_subject_no[i][j] = Fonts.new("#{i}", 400 * @posi[1] + 180 + 30 * posi_x[j], 170 + 30 * posi_y[j], 50) 
        end
      elsif i == 7
        for j in 0 .. 6
          @font_subject_no[i][j] = Fonts.new("#{i}", 400 * @posi[1] + 180 + 30 * posi_x[j], 170 + 30 * posi_y[j], 50) 
        end
      elsif i == 8
        for j in 0 .. 7
          @font_subject_no[i][j] = Fonts.new("#{i}", 400 * @posi[1].to_i + 180 + 30 * posi_x[j].to_i, 170 + 30 * posi_y[j].to_i, 50) 
        end
      elsif i == 9
        for j in 0 .. 8
          @font_subject_no[i][j] = Fonts.new("#{i}", 400 * @posi[1].to_i + 180 + 30 * posi_x[j].to_i, 170 + 30 * posi_y[j].to_i, 50) 
        end
      end
    end
  end
  
  def update
    for i in 0 .. 1
      if @btn_click[i].pushed? and @flag_next == 0
        $time_start = S_Timer.get
        $time_sssss = S_Timer.reset
        if i == 0
          #$file.puts "練習,○,#{$num_q[$count]},#{@font_subject[$num_q[$count]].size},#{$num_q_no[$count]},#{$num_q_no[$count]},#{$time_start},#{@posi}" if $flag_subject == 0
          #$file.puts "本番,○,#{$num_q[$count]},#{(@font_subject[$num_q[$count]].size)},#{$num_q_no[$count]},#{$num_q_no[$count]},#{$time_start},#{@posi}" if $flag_subject == 1
          @flag_judge = 1
          @flag_collect = 1
          $score += 100/COUNT_Q
        elsif i == 1
          #$file.puts "練習,×,#{$num_q[$count]},#{(@font_subject[$num_q[$count]].size)},#{$num_q_no[$count]},#{$num_q_no[$count]},#{$time_start},#{@posi}" if $flag_subject == 0
          #$file.puts "本番,×,#{$num_q[$count]},#{(@font_subject[$num_q[$count]].size)},#{$num_q_no[$count]},#{$num_q_no[$count]},#{$time_start},#{@posi}" if $flag_subject == 1
          @flag_judge = 1
          @flag_collect = 2
        end
      end
    end
    
    if @flag_judge == 1
      #if Input.key_push?( K_RETURN )
      if @btn_judge.pushed?
        $time_sssss = S_Timer.get
        @flag_judge = 1
        if @flag_collect == 1
          $seikai.play 
          $file.puts "#{$start[$flag_subject]},#{$num_q[$count]},#{@font_subject[$num_q[$count]].size},#{$num_q_no[$count]},#{$num_q_no[$count]},#{@posi_log[@posi[0]]},○,#{$time_start},#{$time_sssss}" 
        elsif @flag_collect == 2
          $hazure.play
          $file.puts "#{$start[$flag_subject]},#{$num_q[$count]},#{(@font_subject[$num_q[$count]].size)},#{$num_q_no[$count]},#{$num_q_no[$count]},#{@posi_log[@posi[0]]},×,#{$time_start},#{$time_sssss}" 
          
        end
        @flag_judge = 2
        @flag_next = 1
      end
    end
    
    if @flag_next == 1
      if @btn_next.pushed?
        @flag_next_push = 1
        $time_start = S_Timer.reset
        $count += 1
        if $count != $num_p
          self.next_scene = Game_Scene_1
        else
          self.next_scene = End_Scene_1
        end
      end
    end
    if @btn_back.pushed?
      self.next_scene = Title_Scene_1
    end
    if @btn_setsumei.pushed?
      @flag_setsumei = 1
    end
  end
  
  def render
    if @flag_judge == 1
      @btn_judge.render
    end
    for i in 0 .. 1
      if @flag_collect == 1
        @sel_click[0].render
      elsif @flag_collect == 2
        @sel_click[1].render
      end
    end
    for i in 0 .. 1
      @btn_click[i].render
    end
    #@btn_setsumei.render
    if @flag_next == 1
      @btn_next.render
      @font_remainder.render if $count != COUNT_Q - 1 and $count != COUNT_Q
    end
    if @flag_setsumei == 1
      #@font_setsumei11.render
      #@font_setsumei12.render
      #@font_setsumei21.render
      #@font_setsumei22.render
    end
    
    $time_saaaa = S_Timer.get
    if $time_saaaa > 0.1
      for i in 0 .. 9
        if $num_q[$count] == i
          for j in 0 .. (@font_subject[i].size - 1)
            @font_subject[i][j].render
          end
        end
      end
    end
    
    $time_saaaa = S_Timer.get
    if $time_saaaa > 0.1
      if $num_q_no[$count] == 1
        @font_subject_no[$num_q_no[$count]][0].render
      elsif $num_q_no[$count] == 2
        for j in 0 .. 1
          @font_subject_no[$num_q_no[$count]][j].render
        end
      elsif $num_q_no[$count] == 3
        for j in 0 .. 2
          @font_subject_no[$num_q_no[$count]][j].render
        end
      elsif $num_q_no[$count] == 4
        for j in 0 .. 3
          @font_subject_no[$num_q_no[$count]][j].render
        end
      elsif $num_q_no[$count] == 5
        for j in 0 .. 4
          @font_subject_no[$num_q_no[$count]][j].render
        end
      elsif $num_q_no[$count] == 6
        for j in 0 .. 5
          @font_subject_no[$num_q_no[$count]][j].render
        end
      elsif $num_q_no[$count] == 7
        for j in 0 .. 6
          @font_subject_no[$num_q_no[$count]][j].render
        end
      elsif $num_q_no[$count] == 8
        for j in 0 .. 7
          @font_subject_no[$num_q_no[$count]][j].render
        end
      elsif $num_q_no[$count] == 9
        for j in 0 .. 8
          @font_subject_no[$num_q_no[$count]][j].render
        end
      end
    end
    
    
    
    if @flag_next_push == 0
    elsif @flag_next_push == 1
    end
    #@font_remainder.render
    @btn_back.render
  end
end
######################################################
class End_Scene_1 < Scene::Base
  def init
    @btn_return = Button.new(Window_w/2-72, Window_h/2+200, "戻る",36,144,72)
    @btn_esc = Button.new(Window_w-72, 0, "終了", 16,72,36)
    @font_end = Fonts.new("おつかれさまでした",100 ,180, 100)
    @font_score = Fonts.new("#{$score}点です",300 ,380, 100)
    $time = S_Timer.get
    #$file.puts ",,,,,,,,#{$time},得点,#{$score},,"
  end
  def update
    if @btn_return.pushed?
      $file.puts "初めに戻った"
      $file.puts " "
      self.next_scene = Title_Scene_1
    elsif @btn_esc.pushed?
      exit
    end
  end
  def render
    @btn_return.render
    @btn_esc.render
    @font_end.render
    @font_score.render
  end
end

####################################################################################################

$p = 0
$flag_previously = Array.new(3)
class Title_Scene_3 < Scene::Base
  def init
    $file.puts "形ストループ"
    $file.puts "問題種,不一致形,不一致文字,一致形,一致文字,不一致カード位置,正否,課題解答時間,選択理由解答時間"
    @btn_back_title = Button.new(Window_w-72*2, 36, "初めに戻る", 16, 72*2, 36)
    $start = %w[練習 開始]
    @btn_start = Array.new(2)
    for i in 0 .. 1
      @btn_start[i] = Button.new(Window_w/2-230 + 144, 500 + 100 * 0, "#{$start[i]}",36,144,72) if i == 1
      @btn_start[i] = Button.new(Window_w/2-230 + 144, 5500 + 100 * i, "#{$start[i]}",36,144,72) if i == 0
    end
    $flag_mode = Array.new(3)
    @btn_mode = Array.new(3)
    $mode = %w[  ]
    for i in 0 .. 2
      $flag_mode[i] = 0
      $flag_mode[i] = 1 if i == 0 and $p == 0
      $flag_mode[i] = 1 if $flag_previously[i] == 1
      @btn_mode[i] = Button.new(225 + 200 * i, 380, "#{$mode[i]}",36,144,72)
      @btn_mode[i] = Button.new(225 + 200 * i, 380, "#{$mode[i]}",36,144,72,Red) if i == 0 and $p == 0
      @btn_mode[i] = Button.new(225 + 200 * i, 380, "#{$mode[i]}",36,144,72,Red) if $flag_previously[i] == 1
    end
    @btn_full = Button.new(Window_w-72*2, 0, "full/win", 16,72,36)
    @btn_esc = Button.new(Window_w-72, 0, "終了", 16,72,36)
    @title = Fonts.new("",120 ,180, 100)
    $score = 0
    $num_q = COUNT_Q
    $count = 0#Game_Sceneで何回目か
  end
  def update
    if @btn_full.pushed?
      if Window.windowed?
        Window.windowed = false
      else
        Window.windowed = true
      end
    elsif @btn_esc.pushed?
      exit
    elsif @btn_back_title.pushed?
      self.next_scene = Title_Scene
    end
    k = 0
    for i in 0 .. 2
      if @btn_mode[i].pushed?
        if i == k
          for j in 0 .. 2
            if j == k
              $flag_mode[j] = 1
              @btn_mode[j] = Button.new(225 + 200 * j, 380, "#{$mode[j]}",36,144,72,Red)
            else
              $flag_mode[j] = 0
              @btn_mode[j] = Button.new(225 + 200 * (j), 380, "#{$mode[j]}",36,144,72)
            end
          end
        end
      end
      k += 1
    end
    for i in 0 .. 1
      if @btn_start[i].pushed?
        $time_start = S_Timer.reset
        self.next_scene = Game_Scene_3
        if i == 0
          $num_q = 4
          $flag_subject = 0
        elsif i == 1
          $flag_subject = 1
        end
      end
    end
  end
  def render
    @btn_back_title.render
    @btn_full.render
    @btn_esc.render
    #@title.render
    for i in 0 .. 1
      @btn_start[i].render
    end
    #for i in 0 .. 2
    #  @btn_mode[i].render
    #end
  end
end
####################################################################################################
class Game_Scene_3 < Scene::Base
  def init
    $p += 1
    @btn_back = Button.new(Window_w-72, 0, "戻る", 16, 72, 36)
    @font_remainder = Fonts.new("残り#{$num_q - $count - 1}問",450 ,560, 30)
    @flag_next = 0
    @btn_next = Button.new(450, 610, "次へ", 40, 120, 50)
    @btn_next = Button.new(450, 610, "終わり", 40, 120, 50) if $count == COUNT_Q - 1
    @btn_judge = Button.new(450, 550, "判定", 40, 120, 50)
    @btn_click = Array.new(2)
    @sel_click = Array.new(2)
    @flag_collect = 0
    for i in 0 .. 2
      if $flag_mode[i] == 1
        $flag_previously[i] = 1
      else
        $flag_previously[i] = 0
      end
    end
    @shape = %w[★ ● ▲ ■]
    @string = %w[星 丸 三角 四角]
    if $count == 0
      @q_shape_num = rand(4)
      begin
        @q_string_num = rand(4)
      end while @q_shape_num == @q_string_num
      begin
        @q_match_num = rand(4)
      end while @q_shape_num == @q_match_num or @q_string_num == @q_match_num
    else
      begin
        @q_shape_num = rand(4)
      end while @q_shape_num == $q_shape_num_pre
      begin
        @q_string_num = rand(4)
      end while @q_string_num == $q_string_num_pre or @q_shape_num == @q_string_num
      begin
        @q_match_num = rand(4)
      end while @q_shape_num == @q_match_num or @q_string_num == @q_match_num or @q_match_num == $q_match_num_pre
    end
    $q_shape_num_pre = @q_shape_num
    $q_string_num_pre = @q_string_num
    $q_match_num_pre = @q_match_num
    
    @posi = [0, 1] if $count == 0
    @posi = [1, 0] if $count == 1
    @posi = [0, 1] if $count == 2
    @posi = [0, 1] if $count == 3
    @posi = [1, 0] if $count == 4
    @posi = [1, 0] if $count == 5
    @posi = [0, 1] if $count == 6
    @posi = [1, 0] if $count == 7
    @posi = [0, 1] if $count == 8
    @posi = [1, 0] if $count == 9
    for i in 0 .. 1
      @btn_click[i] = Button.new(400 * @posi[i] + 140, 150, "　", 80, 340, 340, White, gr_color = [0,0,0],cg_color = [0,0,0],mz_color=[0,0,0])
      @sel_click[i] = Button.new(400 * @posi[i] + 140 - 10, 150 - 10, "　", 80, 340 + 20, 340 + 20, Usui, gr_color = [0,0,0],cg_color = [0,0,0],mz_color=[0,0,0])
    end
    
    @subject_shape = Array.new(2)
    @subject_string = Array.new(2)
    for i in 0 .. 1
      if i == 0
        @subject_shape[i] = Fonts.new("#{@shape[@q_shape_num]}",400 * @posi[i] + 200 ,150, 200)
        @subject_string[i] = Fonts.new("#{@string[@q_string_num]}",400 * @posi[i] + 200 ,360, 100)
        if @q_string_num == 0 or @q_string_num == 1
          @subject_string[i] = Fonts.new("#{@string[@q_string_num]}",400 * @posi[i] + 250 ,360, 100)
        end
      elsif i == 1
        @subject_shape[i] = Fonts.new("#{@shape[@q_match_num]}",400 * @posi[i] + 200 ,150, 200)
        @subject_string[i] = Fonts.new("#{@string[@q_match_num]}",400 * @posi[i] + 200 ,360, 100)
        if @q_match_num == 0 or @q_match_num == 1
          @subject_string[i] = Fonts.new("#{@string[@q_match_num]}",400 * @posi[i] + 250 ,360, 100)
        end
      end
    end
    @posi_subject = %w[左 右]
  end
  
  def update
    for i in 0 .. 1
      if @btn_click[i].pushed? and @flag_next == 0
        $time_start = S_Timer.get
        $time_sssss = S_Timer.reset
        @flag_next = 1
        if i == 0
          @flag_collect = 1
          $score += 100/COUNT_Q
        elsif i == 1
          @flag_collect = 2
        end
      end
    end
    if @flag_next == 1
      #if Input.key_push?( K_RETURN )
      if @btn_judge.pushed?
        @flag_next = 2
        $time_sssss = S_Timer.get
        if @flag_collect == 1
          $seikai.play
          $file.puts "#{$start[$flag_subject]},#{@shape[@q_shape_num]},#{@string[@q_string_num]},#{@shape[@q_match_num]},#{@string[@q_match_num]},#{@posi_subject[@posi[0]]},○,#{$time_start},#{$time_sssss}"
        
        elsif @flag_collect == 2
          $hazure.play
          $file.puts "#{$start[$flag_subject]},#{@shape[@q_shape_num]},#{@string[@q_string_num]},#{@shape[@q_match_num]},#{@string[@q_match_num]},#{@posi_subject[@posi[0]]},×,#{$time_start},#{$time_sssss}"
        
        end
      end
    end
    if @flag_next == 2
      if @btn_next.pushed?
        $time_start = S_Timer.reset
        $count += 1
        if $count != $num_q
          self.next_scene = Game_Scene_3
        else
          self.next_scene = End_Scene_3
        end
      end
    end
    if @btn_back.pushed?
      self.next_scene = Title_Scene_3
    end
  end
  
  def render
    for i in 0 .. 1
      if @flag_collect == 1
        @sel_click[0].render
      elsif @flag_collect == 2
        @sel_click[1].render
      end
    end
    for i in 0 .. 1
      @btn_click[i].render
      @subject_shape[i].render
      @subject_string[i].render
    end
    if @flag_next == 1
      @btn_judge.render
    elsif @flag_next == 2
      @btn_next.render
      @font_remainder.render if $count != COUNT_Q - 1 and $count != COUNT_Q
    end
    
    #@font_remainder.render
    @btn_back.render
  end
end
######################################################
class End_Scene_3 < Scene::Base
  def init
    @btn_return = Button.new(Window_w/2-72, Window_h/2+200, "戻る",36,144,72)
    @btn_esc = Button.new(Window_w-72, 0, "終了", 16,72,36)
    @font_end = Fonts.new("おつかれさまでした",100 ,180, 100)
    @font_score = Fonts.new("#{$score}点です",300 ,380, 100)
    $time = S_Timer.get
    #$file.puts ",,,,,,,,#{$time},得点,#{$score},,"
  end
  def update
    if @btn_return.pushed?
      $file.puts "初めに戻った"
      $file.puts " "
      self.next_scene = Title_Scene_3
    elsif @btn_esc.pushed?
      exit
    end
  end
  def render
    @btn_return.render
    @btn_esc.render
    @font_end.render
    @font_score.render
  end
end
####################################################################################################


######################################################
$p = 0
$flag_previously = Array.new(3)
class Title_Scene_2 < Scene::Base
  def init
    $file.puts "空間ストループ"
    $file.puts "問題種,モード,不一致文字,不一致位置,一致文字,一致位置,不一致カード位置,正否,課題解答時間,選択理由解答時間"
    @btn_back_title = Button.new(Window_w-72*2, 36, "初めに戻る", 16, 72*2, 36)
    $start = %w[練習 開始]
    @btn_start = Array.new(2)
    for i in 0 .. 1
      @btn_start[i] = Button.new(Window_w/2-230 + 144, 500 + 100 * 0, "#{$start[i]}",36,144,72) if i == 1
      @btn_start[i] = Button.new(Window_w/2-230 + 144, 9900 + 100 * i, "#{$start[i]}",36,144,72) if i == 0
    end
    $flag_mode = Array.new(3)
    @btn_mode = Array.new(3)
    $mode = %w[右左上下 東西南北 →←↑↓]
    for i in 0 .. 2
      $flag_mode[i] = 0
      $flag_mode[i] = 1 if i == 0 and $p == 0
      $flag_mode[i] = 1 if $flag_previously[i] == 1
      @btn_mode[i] = Button.new(225 + 200 * i, 380, "#{$mode[i]}",36,144,72)
      @btn_mode[i] = Button.new(225 + 200 * i, 380, "#{$mode[i]}",36,144,72,Red) if i == 0 and $p == 0
      @btn_mode[i] = Button.new(225 + 200 * i, 380, "#{$mode[i]}",36,144,72,Red) if $flag_previously[i] == 1
    end
    @btn_full = Button.new(Window_w-72*2, 0, "full/win", 16,72,36)
    @btn_esc = Button.new(Window_w-72, 0, "終了", 16,72,36)
    @title = Fonts.new("空間ストループ改",120 ,180, 100)
    $score = 0
    $num_p = COUNT_Q
    $count = 0#Game_Sceneで何回目か
    $num_q = [0, 1, 2, 3, 0, 1, 2, 3, 0, 1, 2, 3]#下 右 上 左の課題が出る####################################################################################################
    $num_q_no = [0, 1, 2, 3, 0, 1, 2, 3, 0, 1, 2, 3].sort_by{rand}#下 右 上 左の課題が出る####################################################################################################
  end
  def update
    if @btn_full.pushed?
      if Window.windowed?
        Window.windowed = false
      else
        Window.windowed = true
      end
    elsif @btn_esc.pushed?
      exit
    elsif @btn_back_title.pushed?
      self.next_scene = Title_Scene
    end
    k = 0
    for i in 0 .. 2
      if @btn_mode[i].pushed?
        if i == k
          for j in 0 .. 2
            if j == k
              $flag_mode[j] = 1
              @btn_mode[j] = Button.new(225 + 200 * j, 380, "#{$mode[j]}",36,144,72,Red)
            else
              $flag_mode[j] = 0
              @btn_mode[j] = Button.new(225 + 200 * (j), 380, "#{$mode[j]}",36,144,72)
            end
          end
        end
      end
      k += 1
    end
    for i in 0 .. 1
      if @btn_start[i].pushed?
        $time_start = S_Timer.reset
        self.next_scene = Game_Scene_2
        if i == 0
          $num_p = 4
          $flag_subject = 0
        elsif i == 1
          $flag_subject = 1
        end
      end
    end
  end
  def render
    @btn_back_title.render
    @btn_full.render
    @btn_esc.render
    #@title.render
    for i in 0 .. 1
      @btn_start[i].render if i == 1
    end
    for i in 0 .. 2
      @btn_mode[i].render
    end
  end
end
####################################################################################################
class Game_Scene_2 < Scene::Base
  def init
    $p += 1
    @btn_back = Button.new(Window_w-72, 0, "戻る", 16, 72, 36)
    @font_remainder = Fonts.new("残り#{$num_p - $count - 1}問",450 ,560, 30)
    @flag_next = 0
    @btn_next = Button.new(450, 610, "次へ", 40, 120, 50)
    @btn_next = Button.new(450, 610, "終わり", 40, 120, 50) if $count == COUNT_Q - 1
    @btn_judge = Button.new(450, 550, "判定", 40, 120, 50)
    @btn_select = Array.new(4)
    @btn_select_no = Array.new(4)
    @subject = Array.new(4)
    @subject_no = Array.new(4)
    @font_subject = Array.new(3)
    @font_subject_log = Array.new(3)
    @mode_presentation = [%w[下 右 上 左], %w[南 東 北 西], %w[↓ → ↑ ←]]
    @mode_presentation_log = [%w[上 左 下 右], %w[北 西 南 東], %w[↑ ← ↓ →]]
    @posi_log = %w[左 右]
    @posi = [0, 1] if $count == 0
    @posi = [1, 0] if $count == 1
    @posi = [0, 1] if $count == 2
    @posi = [0, 1] if $count == 3
    @posi = [1, 0] if $count == 4
    @posi = [1, 0] if $count == 5
    @posi = [0, 1] if $count == 6
    @posi = [1, 0] if $count == 7
    @posi = [0, 1] if $count == 8
    @posi = [1, 0] if $count == 9
    
    @btn_click = Array.new(2)
    @sel_click = Array.new(2)
    @flag_next_push = 0
    for i in 0 .. 2
      if $flag_mode[i] == 1
        @font_subject[i] = @mode_presentation[i]
        @font_subject_log[i] = @mode_presentation_log[i]
        $flag_previously[i] = 1
      else
        $flag_previously[i] = 0
      end
    end
    for j in 0 .. 2
      if $flag_mode[j] == 1
      for i in 0 .. 3
        if i == $num_q[$count]#@font_subject[0][$num_q[$count]]
          if i == 0
            @btn_select[i] = Button.new(400 * @posi[0] + 170 + 100 * (i + 1), 170 + 100 * i, "#{@font_subject[j][i]}", 80, 80, 80, White, gr_color = [0,0,0],cg_color = [0,0,0],mz_color=[0,0,0])
          elsif i == 3
            @btn_select[i] = Button.new(400 * @posi[0] + 170 + 100 * (i - 1), 170 + 100 * (i - 2), "#{@font_subject[j][i]}", 80, 80, 80, White, gr_color = [0,0,0],cg_color = [0,0,0],mz_color=[0,0,0])
          elsif i == 1
            @btn_select[i] = Button.new(400 * @posi[0] + 170 + 100 * (i - 1), 170 + 100 * i, "#{@font_subject[j][i]}", 80, 80, 80, White, gr_color = [0,0,0],cg_color = [0,0,0],mz_color=[0,0,0])
          elsif i == 2
            @btn_select[i] = Button.new(400 * @posi[0] + 170 + 100 * (i - 1), 170 + 100 * i, "#{@font_subject[j][i]}", 80, 80, 80, White, gr_color = [0,0,0],cg_color = [0,0,0],mz_color=[0,0,0])
          end
        end
        if i == $num_q_no[$count]
          if i == 0
            @btn_select_no[i] = Button.new(400 * @posi[1] + 170 + 100 * (i + 1), 170 + 100 * i, "#{@font_subject_log[j][i]}", 80, 80, 80, White, gr_color = [0,0,0],cg_color = [0,0,0],mz_color=[0,0,0])
          elsif i == 3
            @btn_select_no[i] = Button.new(400 * @posi[1] + 170 + 100 * (i - 1), 170 + 100 * (i - 2), "#{@font_subject_log[j][i]}", 80, 80, 80, White, gr_color = [0,0,0],cg_color = [0,0,0],mz_color=[0,0,0])
          elsif i == 1
            @btn_select_no[i] = Button.new(400 * @posi[1] + 170 + 100 * (i - 1), 170 + 100 * i, "#{@font_subject_log[j][i]}", 80, 80, 80, White, gr_color = [0,0,0],cg_color = [0,0,0],mz_color=[0,0,0])
          elsif i == 2
            @btn_select_no[i] = Button.new(400 * @posi[1] + 170 + 100 * (i - 1), 170 + 100 * i, "#{@font_subject_log[j][i]}", 80, 80, 80, White, gr_color = [0,0,0],cg_color = [0,0,0],mz_color=[0,0,0])
          end
        end
      end
      end
    end
    for i in 0 .. 1
      @btn_click[i] = Button.new(400 * @posi[i] + 140, 150, "　", 80, 340, 340, White, gr_color = [0,0,0],cg_color = [0,0,0],mz_color=[0,0,0])
      @sel_click[i] = Button.new(400 * @posi[i] + 140 - 10, 150 - 10, "　", 80, 340 + 20, 340 + 20, Usui, gr_color = [0,0,0],cg_color = [0,0,0],mz_color=[0,0,0])
    end
          #for j in 0 .. 2
          #  if $flag_mode[j] == 1    
          #    @font_setsumei11 = Fonts.new("文字の読み : #{@font_subject[j][$num_q[$count]]}", 400 * @posi[0].to_i + 180, 500, 30) 
          #    @font_setsumei12 = Fonts.new("文字の位置 : #{@font_subject_log[j][$num_q[$count]]}", 400 * @posi[0].to_i + 180, 550, 30) 
          #    @font_setsumei21 = Fonts.new("文字の読み : #{@font_subject_log[j][$num_q_no[$count]]}", 400 * @posi[1].to_i + 180, 500, 30) 
          #    @font_setsumei22 = Fonts.new("文字の位置 : #{@font_subject_log[j][$num_q_no[$count]]}", 400 * @posi[1].to_i + 180, 550, 30) 
          #  end
          #end
    @flag_setsumei = 0
    @flag_setsumei_btn = 0
    @btn_setsumei = Button.new(Window_w-72*3, 0, "説明", 16, 72, 36)
    @flag_judge = 0
    @flag_collect = 0
  end
  
  def update
    for i in 0 .. 1
      if @btn_click[i].pushed? and @flag_next == 0
        @flag_setsumei_btn = 1
        $time_start = S_Timer.get
        $time_sssss = S_Timer.reset
        if i == 0
          for j in 0 .. 2
            if $flag_mode[j] == 1
              #$file.puts "#{$mode[j]},練習,○,#{@font_subject[j][$num_q[$count]]},#{@font_subject_log[j][$num_q_no[$count]]},#{$time_start}" if $flag_subject == 0
              #$file.puts "#{$mode[j]},本番,○,#{@font_subject[j][$num_q[$count]]},#{@font_subject_log[j][$num_q_no[$count]]},#{$time_start}" if $flag_subject == 1
              @flag_judge = 1
              @flag_collect = 1
              $score += 100/COUNT_Q
            end
          end
        elsif i == 1
          for j in 0 .. 2
            if $flag_mode[j] == 1
              #$file.puts "#{$mode[j]},練習,×,#{@font_subject[j][$num_q[$count]]},#{@font_subject_log[j][$num_q_no[$count]]},#{$time_start}" if $flag_subject == 0
              #$file.puts "#{$mode[j]},本番,×,#{@font_subject[j][$num_q[$count]]},#{@font_subject_log[j][$num_q_no[$count]]},#{$time_start}" if $flag_subject == 1
              @flag_judge = 1
              @flag_collect = 2
            end
          end
        end
      end
    end
    if @flag_judge == 1
      #if Input.key_push?( K_RETURN )
      if @btn_judge.pushed?
        $time_sssss = S_Timer.get
        @flag_judge = 1
        if @flag_collect == 1
          $seikai.play 
          for j in 0 .. 2
            if $flag_mode[j] == 1
              $file.puts "#{$mode[j]},#{$start[$flag_subject]},#{@font_subject[j][$num_q[$count]]},#{@font_subject_log[j][$num_q[$count]]},#{@font_subject_log[j][$num_q_no[$count]]},#{@font_subject_log[j][$num_q_no[$count]]},#{@posi_log[@posi[0]]},○,#{$time_start},#{$time_sssss}"
            end
          end
        elsif @flag_collect == 2
          $hazure.play  
          for j in 0 .. 2
            if $flag_mode[j] == 1
              $file.puts "#{$mode[j]},#{$start[$flag_subject]},#{@font_subject[j][$num_q[$count]]},#{@font_subject_log[j][$num_q[$count]]},#{@font_subject_log[j][$num_q_no[$count]]},#{@font_subject_log[j][$num_q_no[$count]]},#{@posi_log[@posi[0]]},×,#{$time_start},#{$time_sssss}"
            end
          end
        end
        @flag_judge = 2
        @flag_next = 1
      end
    end
    if @flag_next == 1
      if @btn_next.pushed?
        @flag_next_push = 1
        $time_start = S_Timer.reset
        $count += 1
        if $count != $num_p
          self.next_scene = Game_Scene_2
        else
          self.next_scene = End_Scene_2
        end
      end
    end
    if @btn_back.pushed?
      self.next_scene = Title_Scene_2
    end
  end
  
  def render
    if @flag_judge == 1
      @btn_judge.render
    end
    for i in 0 .. 1
      if @flag_collect == 1
        @sel_click[0].render
      elsif @flag_collect == 2
        @sel_click[1].render
      end
    end
    for i in 0 .. 1
      @btn_click[i].render
    end
    if @flag_next == 1
      @btn_next.render
      @font_remainder.render if $count != COUNT_Q - 1 and $count != COUNT_Q
    end
    
    if @flag_setsumei == 1
      @font_setsumei11.render
      @font_setsumei12.render
      @font_setsumei21.render
      @font_setsumei22.render
    end
    if @flag_setsumei_btn == 1
      #@btn_setsumei.render
    end
    
    if @flag_next_push == 0
      @btn_select[$num_q[$count]].render
      @btn_select_no[$num_q_no[$count]].render
    elsif @flag_next_push == 1
      @btn_select[$num_q[$count - 1]].render
      @btn_select_no[$num_q_no[$count - 1]].render
    
    end
    #@font_remainder.render
    @btn_back.render
  end
end
######################################################
class End_Scene_2 < Scene::Base
  def init
    @btn_return = Button.new(Window_w/2-72, Window_h/2+200, "戻る",36,144,72)
    @btn_esc = Button.new(Window_w-72, 0, "終了", 16,72,36)
    @font_end = Fonts.new("おつかれさまでした",100 ,180, 100)
    @font_score = Fonts.new("#{$score}点です",300 ,380, 100)
    $time = S_Timer.get
    #$file.puts ",,,,,,,,#{$time},得点,#{$score},,"
  end
  def update
    if @btn_return.pushed?
      $file.puts "初めに戻った"
      $file.puts " "
      self.next_scene = Title_Scene_2
    elsif @btn_esc.pushed?
      exit
    end
  end
  def render
    @btn_return.render
    @btn_esc.render
    @font_end.render
    @font_score.render
  end
end
####################################################################################################
########################################################
########################################################
Scene.main_loop Title_Scene
