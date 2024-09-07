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
require 'lib/sub_class.rb'
require "lib/checkbox_for_dxruby"
######################################################
Black = [0, 0, 0]
White = [255, 255, 255]
Green = [0, 255, 0]
Blue = [0, 0, 255]
Red = [255, 0, 0]
Orange = [255, 255, 0]
Gray = [110, 110, 110]
######################################################
Window_w = 1024
Window_h = 768
Window.width  = Window_w
Window.height = Window_h
Window.bgcolor = White
Window.caption = "シューティング"
Window.fps = 60
FPS = 60
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
  $file.puts "音の数,提示方法,文字の種類,音韻訓練,シーン,射撃的,時間,成否"
end
logfile_open("シューティング") 

def logfile_point_open(string)
  date = Time.now.strftime("%Y.%m.%d_%H.%M.%S")
  fname = "log_point/#{string}_#{date}.csv"
  $file_point = File::open(fname, "w")
  $file_point.puts "時間,マウスx,マウスy,風船0,風船0x,風船0y,風船1,風船1x,風船1y,風船2,風船2x,風船2y,風船3,風船3x,風船3y,風船4,風船4x,風船4y,"
end
#######################################################
class S_Timer
  def self.reset  #時間を初期化
    @start_time = Time.now
  end

  def self.get  #経過時間を得る
    return Time.now - @start_time
  end
end

####################################################################################################
#ゲーム全体で扱うグローバル変数を定義
#$count = 0        # ゲームの回数
#$score = 100        # 点数
$flag_oto = 0     # 0:単音, 1:2音以上
$flag_teiji = 0   # 0:視覚提示, 1:聴覚提示
$flag_moji = 0    # 0:ひらがな, 1:カタカナ, 2:アルファベット大, 3:アルファベット小
$flag_mode = 0    # 0:順唱, 1:逆唱, 2:削除, 3:抽出
####################################################################################################
class Setup_Scene < Scene::Base
  def init
    @btn_full = Button.new(Window_w-72*2, 0, "full/win", 16,72,36)
    @btn_esc = Button.new(Window_w-72, 0, "終了", 16,72,36)
    @btn_start = Button.new(800, 650, "決定", 32,144,72)
    @image = Image.load("image/Setup_bg.png", 0, 0, 1024, 768)
    
    ##ゲーム全体で扱うグローバル変数を定義
    #$count = 0        # ゲームの回数
    #$score = 100        # 点数
    #$flag_oto = 0     # 0:単音, 1:2音以上
    #$flag_teiji = 0   # 0:視覚提示, 1:聴覚提示
    #$flag_moji = 0    # 0:ひらがな, 1:カタカナ, 2:アルファベット大, 3:アルファベット小
    #$flag_mode = 0    # 0:順唱, 1:逆唱, 2:削除, 3:抽出
    
    Input.mouseEnable=true #矢印マウスカーソルを表示
    check_init
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
    end
    
    self.next_scene = Title_Scene if @btn_start.pushed?
    
    check_update
  end
  
  def render
    Window.draw(0,0,@image)
    @btn_full.render
    @btn_esc.render
    @btn_start.render
    
    check_render
  end
  
  #--------------------------------------------------------
  
  def check_init
    check_x, check_y = 300, 125
    
    #音の数
    @check_oto = Array.new()
    @check_oto[0] = Checkbox.new(check_x, check_y,"単音")
    @check_oto[1] = Checkbox.new(check_x+200, check_y,"2音以上")
    @check_oto[$flag_oto].set
    
    #提示方法
    @check_teiji = Array.new()
    @check_teiji[0] = Checkbox.new(check_x, check_y+95,"視覚提示")
    @check_teiji[1] = Checkbox.new(check_x+200, check_y+95,"聴覚提示")
    @check_teiji[$flag_teiji].set
    
    #文字の種類
    @check_moji = Array.new()
    @check_moji[0] = Checkbox.new(check_x, check_y+185,"ひらがな")
    @check_moji[1] = Checkbox.new(check_x+300, check_y+185,"カタカナ")
    @check_moji[2] = Checkbox.new(check_x, check_y+255,"アルファベット(大)")
    @check_moji[3] = Checkbox.new(check_x+300, check_y+255,"アルファベット(小)")
    @check_moji[$flag_moji].set
    
    #音韻訓練モード
    @check_mode = Array.new()
    @check_mode[0] = Checkbox.new(check_x, check_y+335,"順唱")
    @check_mode[1] = Checkbox.new(check_x+300, check_y+335,"逆唱")
    @check_mode[2] = Checkbox.new(check_x, check_y+405,"削除")
    @check_mode[3] = Checkbox.new(check_x+300, check_y+405,"抽出")
    @check_mode[$flag_mode].set
  end
  
  def check_update
    #音の数
    if @check_oto[0].clicked?
      @check_oto[1].reset
      $flag_oto = 0
    elsif @check_oto[1].clicked?
      @check_oto[0].reset
      $flag_oto = 1
    end
    
    #提示方法
    if @check_teiji[0].clicked?
      @check_teiji[1].reset
      $flag_teiji = 0
    elsif @check_teiji[1].clicked?
      @check_teiji[0].reset
      $flag_teiji = 1
    end
    
    #文字の種類
    if @check_moji[0].clicked?
      @check_moji[1].reset
      @check_moji[2].reset
      @check_moji[3].reset
      $flag_moji = 0
    elsif @check_moji[1].clicked?
      @check_moji[0].reset
      @check_moji[2].reset
      @check_moji[3].reset
      $flag_moji = 1
    elsif @check_moji[2].clicked?
      @check_moji[0].reset
      @check_moji[1].reset
      @check_moji[3].reset
      $flag_moji = 2
    elsif @check_moji[3].clicked?
      @check_moji[0].reset
      @check_moji[1].reset
      @check_moji[2].reset
      $flag_moji = 3
    end
    
    #音韻訓練モード
    if $flag_oto == 1
      if @check_mode[0].clicked?
        @check_mode[1].reset
        @check_mode[2].reset
        @check_mode[3].reset
        $flag_mode = 0
      elsif @check_mode[1].clicked?
        @check_mode[0].reset
        @check_mode[2].reset
        @check_mode[3].reset
        $flag_mode = 1
      elsif @check_mode[2].clicked?
        @check_mode[0].reset
        @check_mode[1].reset
        @check_mode[3].reset
        $flag_mode = 2
      elsif @check_mode[3].clicked?
        @check_mode[0].reset
        @check_mode[1].reset
        @check_mode[2].reset
        $flag_mode = 3
      end
    end
  end
  
  def check_render
    #音の数
    @check_oto.each do |i|
      i.draw
    end
    #提示方法
    @check_teiji.each do |i|
      i.draw
    end
    #文字の種類
    @check_moji.each do |i|
      i.draw
    end
    #音韻訓練モード
    if $flag_oto == 1
      @check_mode.each do |i|
        i.draw
      end
    end
  end
  
end

####################################################################################################
class Title_Scene < Scene::Base
  def init
    @btn_start = Button.new(600, 380, "", 16,200,120,[0,255,255,255],[0,255,255,255],[0,255,255,255])
    @btn_back = Button.new(600, 510, "", 16,200,120,[0,255,255,255],[0,255,255,255],[0,255,255,255])
    @btn_end = Button.new(600, 650, "", 16,200,120,[0,255,255,255],[0,255,255,255],[0,255,255,255])
    @image = Image.load("image/back_ground.png", 0, 0, 1024, 768)
    @gun = Gun_cursor.new#銃弾に制限があるほうがいいかも
    $count = 0        # ゲームの回数
    $score = 100        # 点数
  end
  
  def update
    self.next_scene = Present_Scene if @btn_start.pushed?
    self.next_scene = Setup_Scene if @btn_back.pushed?
    exit if @btn_end.pushed?
    @gun.update
    #screen_shot
  end
  
  def screen_shot# スクリーンショット機能
    if Input.keyPush?(K_F12) == true then
      if ! File.exist?("screenshot") then
        Dir.mkdir("screenshot")
      end
      Window.getScreenShot("screenshot/screenshot" + Time.now.strftime("%Y%m%d_%H%M%S") + ".jpg")
    end
  end
  
  def render
    Window.draw(0,0,@image)
    @gun.render
    @btn_start.render
    @btn_back.render
    @btn_end.render
  end
end#class
####################################################################################################
class Present_Scene < Scene::Base
  def init
    #logfile_point_open("シューティング")
    @btn_full = Button.new(Window_w-72*2, 0, "full/win", 16,72,36)
    @btn_esc = Button.new(Window_w-72, 0, "終了", 16,72,36)
    @btn_start = Button.new(550, 600, "", 32,300,150,[0,255,255,255],[0,255,255,255],[0,255,255,255])
    @image = Image.load("image/wanted.png", 0, 0, 1024, 768)
    @gun = Gun_cursor.new#銃弾に制限があるほうがいいかも
    
    #グローバル変数によるflag作成
    $num_select = 5 # 風船の個数
    
    #ファイルを読み込み正解の文字列を作成
    make_question if $count == 0
    
    #Setup_Sceneの$flagに応じてメソッドを使用
    init_visual if $flag_teiji == 0
    init_hearing if $flag_teiji == 1
    init_onin if $flag_mode != 0 
    
    #実際に問題となる文字列の作成
    make_select
    
  end
  
  #視覚提示の場合のinitialize
  def init_visual
    @font_wanted = Array.new()
    for i in 0..$question[$count].size-1
      @font_wanted[0] = Fonts.new("#{$question[$count][0]}",400,220,200) if $flag_oto == 0 #,300+144*i,400,288
      @font_wanted[i] = Fonts.new("#{$question[$count][i]}",300+144*i,230,144) if $flag_oto == 1 #,300+144*i,400,288
      #@font_wanted[i].x =Window_w/2 - 35*(@font_wanted[i].string).size/2 if $flag_oto == 0
    end
  end
  
  #聴覚提示の場合のinitialize
  def init_hearing
    @second= 0
    @btn_oto = Button.new(500, 300, "♪", 32,72,32,[0,0,0])
    
    @sound_wanted = Array.new()
    for i in 0..$question[$count].size-1
      @sound_wanted[i] = Sound.new("sound/kana_sound/#{$question[$count][i]}.wav")
    end
  end
  
  #音韻モードの表示メッセージ
  def init_onin
    @color_red = 255
    if $flag_mode == 1
      @font_re = Fonts.new("うしろからねらって",272,480,72,[255,0,0]) 
    elsif $flag_mode == 2
      if $question[$count].size <= 2
        $var_delete = rand(1)
      elsif $question[$count].size == 3
        $var_delete = rand(2)
      else
        $var_delete = rand(3)
      end
      @font_target = $question[$count][$var_delete]
      @font_re = Fonts.new("「#{@font_target}」をぬいてねらえ",272,500,50,[255,0,0]) if $flag_teiji == 0
      @font_re = Fonts.new("をぬいてねらえ",422,500,50,[255,0,0]) if $flag_teiji == 1
      @btn_delete = Button.new(300, 510, "♪", 32,72,32,[0,0,0]) if $flag_teiji == 1
      @sound_delete = Sound.new("sound/kana_sound/#{@font_target}.wav")
    elsif $flag_mode == 3
      if $question[$count].size <= 2
        @arr_delete = %w(はじめの さいごの)
        $var_delete = rand(1)
      elsif $question[$count].size == 3
        @arr_delete = %w(はじめの まんなかの さいごの)
        $var_delete = rand(2)
      else
        @arr_delete = %w(はじめの 2番目の 3番目の さいごの)
        $var_delete = rand(3)
      end
      
      @font_re = Fonts.new("#{@arr_delete[$var_delete]}文字をねらって",272,500,50,[255,0,0]) 
    end
  end
  
  #ファイル読み込み
  def load_datafile(filename)
    array = []
    open(filename) do |file|
      while l = file.gets
        array.push l.chomp.split(//s)
      end
    end
    return array
  end
  
  #テキストファイルから正解となる文字配列($question)を取り出す
  def make_question
    arr_oto = %w(単音 単語)
    arr_font = %w(ひらがな カタカナ アルファベット大 アルファベット小)#もし漢字に発展してもひらがなで対応できるはず
    $question = load_datafile("question/#{arr_oto[$flag_oto]}(#{arr_font[$flag_moji]}).txt")#問題作成
    #p $question
  end
  
  #選択肢($arr_select)を作成
  def make_select
    arr_moji = Array.new()
    arr_moji[0] = %w(あ い う え お か き く け こ さ し す せ そ た ち つ て と な に ぬ ね の は ひ ふ へ ほ ま み む め も や ゆ よ わ を ん)
    arr_moji[1] = %w(ア イ ウ エ オ カ キ ク ケ コ サ シ ス セ ソ タ チ ツ テ ト ナ ニ ヌ ネ ノ ハ ヒ フ ヘ ホ マ ミ ム メ モ ヤ ユ ヨ ワ ヲ ン)
    arr_moji[2] = %w(A B C D E F G H I J K L M N O P Q R S T U V W X Y Z)
    arr_moji[3] = %w(a b c d e f g h i j k l m n o p q r s t u v w x y z)
    
    #文字群から正解文字を削除
    for i in 0..$question[$count].size - 1
      arr_moji[$flag_moji].delete($question[$count][i])
    end
    arr_others = arr_moji[$flag_moji].sort_by{rand}
    
    #選択肢の文字が入る配列
    $arr_select = Array.new()
    
    #風船の中に書く正解文字を入れる
    for i in 0..$question[$count].size-1
      $arr_select.push($question[$count][i]) if $flag_mode == 0 #ここのpushメソッドをunshiftメソッドと切り替えることによって順唱,逆唱の区別が容易にできるはず
      $arr_select.unshift($question[$count][i]) if $flag_mode == 1 #逆唱
    end
    
    #風船の中に書く正解文字を入れる(削除課題)
    if $flag_mode == 2
      arr_dammy = Marshal.load(Marshal.dump($question[$count])) #$question[$count]の保存用ダミー配列arr_dammyを作成
      $question[$count].delete_at($var_delete)
      for i in 0..$question[$count].size-1
        $arr_select.push($question[$count][i])
      end
      p $var_delete
      p $arr_select
      $arr_select.push(arr_dammy[$var_delete])
      p $arr_select
    end
    
    #風船の中に書く正解文字を入れる(抽出課題)
    if $flag_mode == 3
      arr_dammy = Marshal.load(Marshal.dump($question[$count])) #$question[$count]の保存用ダミー配列arr_dammyを作成
      arr_dammy.delete_at($var_delete) #arr_dammyから抽出すべき文字を削除する
      $arr_select.push($question[$count][$var_delete])#抽出すべき文字が先頭になるように$arr_selectに入れる
      for i in 0..arr_dammy.size-1
        $question[$count].delete(arr_dammy[i])#$question[$count]から正解文字以外を削除→これはゲームシーンで正解を抽出すべき文字だけにするため
      end
      
      for i in 0..arr_dammy.size-1
        $arr_select.push(arr_dammy[i]) 
      end
      p $arr_select
      p $question[$count]
    end
    #風船の中に書く不正解文字を入れる
    for i in 0..$num_select-$arr_select.size-1
      $arr_select.push(arr_others[i])
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
    end
    
    update_hearing if $flag_teiji == 1
    update_onin if $flag_mode != 0 
    
    self.next_scene = Game_Scene if @btn_start.pushed?
    
    @gun.update
  end
  
  #聴覚提示の場合の処理
  def update_hearing
    for i in 0..@sound_wanted.size-1
      @sound_wanted[i].play if @second == 50*i
    end
    @second += 1
    @second = 0 if @btn_oto.pushed?
    if $flag_mode == 2
      @sound_delete.play if @btn_delete.pushed?
    end
  end
  
  #音韻モードの場合の処理
  def update_onin
    @color_red += 1
    if @color_red % 15 == 0
      @font_re = Fonts.new("",272,480,72,[255,0,0]) if $flag_mode == 1
      @font_re = Fonts.new("",272,500,50,[255,0,0]) if $flag_mode == 2
      @font_re = Fonts.new("",272,500,50,[255,0,0]) if $flag_mode == 3
    else
      @font_re = Fonts.new("うしろからねらって",232,480,72,[0,0,0]) if $flag_mode == 1
      @font_re = Fonts.new("「#{@font_target}」をぬいてねらえ",272,500,50,[255,0,0]) if $flag_mode == 2 and $flag_teiji == 0
      @font_re = Fonts.new("をぬいてねらえ",424,500,50,[255,0,0]) if $flag_mode == 2 and $flag_teiji == 1
      @font_re = Fonts.new("#{@arr_delete[$var_delete]}文字をねらって",272,500,50,[0,0,0]) if $flag_mode == 3
    end
  end
  
  def render
    Window.draw(0,0,@image)
    @btn_start.render
    @btn_full.render
    @btn_esc.render
    @font_re.render if $flag_mode != 0 #,300+144*i,400,288
    #@btn_delete if $flag_mode == 2 and $flag_teiji == 1
    #提示方法による分岐
    if $flag_teiji == 0
      @font_wanted.each do |i|
        i.render
      end
    elsif $flag_teiji == 1
      @btn_oto.render
      @btn_delete.render if $flag_mode == 2 
    end
    @gun.render
  end
  
end
####################################################################################################
class Game_Scene < Scene::Base
  def init
    @num=$question.size/5
    @arr_haikei=Array.new()
    for i in 0..$question.size-1
      if (0..@num-1).include?(i)
        @arr_haikei[i]=0
      elsif (@num..@num*1).include?(i)
        @arr_haikei[i]=1
      elsif (@num+1..@num*2).include?(i)
        @arr_haikei[i]=2
      elsif (@num*2+1..@num*3).include?(i)
        @arr_haikei[i]=3
      elsif (@num*3+1..@num*4).include?(i)
        @arr_haikei[i]=4
      else
        @arr_haikei[i]=4
      end
    end
    @image = Image.load("image/bg_#{@arr_haikei[$count]}.png", 0, 0, 1024, 768)#{$count}
    @gun = Gun_cursor.new#銃弾に制限があるほうがいいかも
    @bgm = Sound.new("sound/kujira.mid")
    #@bgm.setVolume(200)
    @bgm.play
    @sound_ok = Sound.new("sound/seikai.wav")
    @sound_bad = Sound.new("sound/hazure.wav")
    @flag_push = :off
    
    make_baloon
    init_tango if $flag_oto == 1
    log_string
    S_Timer.reset
    @font_time = Fonts.new("0",0,0,50,Black)
  end
  
  #単語の時のinitialize
  def init_tango
    @arr_dammy = Array.new($question[$count].size,0)
    @arr_correct = Array.new($question[$count].size,1)
  end
  
  #風船を作る
  def make_baloon
    #以下の処理は風船の数($num_select)を5と仮定
    @baloon = Array.new()
    @baloon_x = [100,300,500,700,900]
    @baloon_x = @baloon_x.sort_by{rand}
    @baloon_y = [768,768,768,768,768]
    @baloon_y = @baloon_y.sort_by{rand}
    for i in 0..$num_select-1
      @baloon[i] = Baloon.new(@baloon_x[i], @baloon_y[i],$arr_select[i],i)
    end
  end
  
  #logに書かれる文字の配列
  def log_string
    @string_oto =%w(単音 2音以上)
    @string_teiji =%w(視覚 聴覚)
    @string_moji =%w(ひらがな カタカナ アルファベット大 アルファベット小)
    @string_mode =%w(順唱 逆唱 削除 抽出)
  end
  
  def update
    #$file_point.puts "#{S_Timer.get},#{@gun.x},#{@gun.y},#{@baloon[0].font},#{@baloon[0].x},#{@baloon[0].y},#{@baloon[1].font},#{@baloon[1].x},#{@baloon[1].y},#{@baloon[2].font},#{@baloon[2].x},#{@baloon[2].y},#{@baloon[3].font},#{@baloon[3].x},#{@baloon[3].y},#{@baloon[4].font},#{@baloon[4].x},#{@baloon[4].y}"
    update_tanon if $flag_oto == 0#単音の場合の正解判定
    update_tango if $flag_oto == 1#2音以上の場合の正解判定
    @font_time = Fonts.new("あと#{20-S_Timer.get.round}秒",0,0,50,White)
    @time =  S_Timer.get
    if @time >= 20
      $score -= 100/$question.size if @flag_push == :off
      self.next_scene = Present_Scene#Commentbad_Scene
      @sound_bad.play
      @bgm.stop
      $count += 1
    end
    @gun.update
    @baloon.each do |i|
      i.update
    end
  end
  
  #単音の場合の処理
  def update_tanon
    #正解の風船を割った時の処理
    if @baloon[0].pushed?
      @baloon[0] = Baloon.new(@baloon_x[0], @baloon_y[0],$arr_select[0],0,1)#風船破壊
      $file.puts "#{@string_oto[$flag_oto]},#{@string_teiji[$flag_teiji]},#{@string_moji[$flag_moji]},#{@string_mode[$flag_mode]},#{$count},#{$arr_select[0]},#{S_Timer.get},○"
      @sound_ok.play
      @bgm.stop
      #$score += 20 if @flag_push == :off
      
      if $count < $question.size-1
        self.next_scene = Present_Scene #if @flag_push == :off
        #self.next_scene = Commentbad_Scene if @flag_push == :on
        @bgm.stop
        $count += 1
      else
        self.next_scene = End_Scene 
        @bgm.stop
      end
    end
    
    #不正解の風船を割った時の処理
    for i in 1..$num_select-1
      if @baloon[i].pushed?
        $score -= 100/$question.size if @flag_push == :off
        @flag_push = :on
        @sound_bad.play
        @baloon[i].color
        #@baloon[i] = Baloon.new(@baloon_x[i], @baloon_y[i],$arr_select[i],i,1)#風船破壊
        $file.puts "#{@string_oto[$flag_oto]},#{@string_teiji[$flag_teiji]},#{@string_moji[$flag_moji]},#{@string_mode[$flag_mode]},#{$count},#{$arr_select[i]},#{S_Timer.get},×"
      end
    end
  end
  
  #単語の場合の処理
  def update_tango
    #単語の先頭の文字を割った時の処理
    if @baloon[0].pushed?
      @arr_dammy[0] = 1 
        @sound_ok.play
        @baloon[0] = Baloon.new(@baloon_x[0], @baloon_y[0],$arr_select[0],0,1)
      $file.puts "#{@string_oto[$flag_oto]},#{@string_teiji[$flag_teiji]},#{@string_moji[$flag_moji]},#{@string_mode[$flag_mode]},#{$count},#{$arr_select[0]},#{S_Timer.get},○"
    end
    
    #単語の先頭以外を割った時の処理
    for i in 1..$question[$count].size-1
      if @baloon[i].pushed?
        if @arr_dammy[i-1] == 1
          @arr_dammy[i] = 1
          @sound_ok.play
          @baloon[i] = Baloon.new(@baloon_x[i], @baloon_y[i],$arr_select[i],i,1)
          $file.puts "#{@string_oto[$flag_oto]},#{@string_teiji[$flag_teiji]},#{@string_moji[$flag_moji]},#{@string_mode[$flag_mode]},#{$count},#{$arr_select[i]},#{S_Timer.get},○"
        else
          @sound_bad.play
          $file.puts "#{@string_oto[$flag_oto]},#{@string_teiji[$flag_teiji]},#{@string_moji[$flag_moji]},#{@string_mode[$flag_mode]},#{$count},#{$arr_select[i]},#{S_Timer.get},×"
        end
      end
    end
    
    #単語をすべて割った時の処理
    if @arr_dammy == @arr_correct
      @bgm.stop
      #$score += 20 if @flag_push == :off
      if $count < $question.size-1
        self.next_scene = Present_Scene #if @flag_push == :off
        #self.next_scene = Commentbad_Scene if @flag_push == :on
        @bgm.stop
        $count += 1
      else
        self.next_scene = End_Scene
        @bgm.stop
      end
    end
    
    #単語以外の言葉を割った時の処理
    for i in $question[$count].size-1..$num_select-1
      if @baloon[i].pushed?
        $score -= 100/$question.size if @flag_push == :off
        @flag_push = :on
        @sound_bad.play
        @baloon[i].color
        $file.puts "#{@string_oto[$flag_oto]},#{@string_teiji[$flag_teiji]},#{@string_moji[$flag_moji]},#{@string_mode[$flag_mode]},#{$count},#{$arr_select[i]},#{S_Timer.get},×"
      end
    end
    
  end
  
  
  def render
    Window.draw(0,0,@image)
    @btn_hint.render if @flag_hint == 1
    @baloon.each do |i|
      i.render
    end
    @gun.render
    @font_time.render
  end
end#class

####################################################################################################
class Commentbad_Scene < Scene::Base
  def init 
    @image = Image.load("image/miss.png")
  end
  
  def update
    self.next_scene = Present_Scene if Input.keyDown?(K_NUMPAD0)
  end
  
  def render
    Window.draw(0,0,@image)
  end
end
####################################################################################################
class Commentok_Scene < Scene::Base
  def init 
    @image = Image.load("image/ok.png")
  end
  
  def update
    self.next_scene = Present_Scene if Input.keyDown?(K_NUMPAD0)
  end
  
  def render
    Window.draw(0,0,@image)
  end
end
####################################################################################################
class End_Scene < Scene::Base
  def init
    @tensuu = 0
    @image = Image.load("image/score.png", 0, 0, 1024, 768)
    @btn_back = Button.new(250, 550, "", 32,200,130,[0,255,255,255],[0,255,255,255],[0,255,255,255])
    @btn_end = Button.new(620, 550, "", 32,200,130,[0,255,255,255],[0,255,255,255],[0,255,255,255])
    @gun = Gun_cursor.new#銃弾に制限があるほうがいいかも
  end
  
  def update
    @tensuu += 1
    @font_score = Fonts.new("#{@tensuu.round}",350,250,144,Black) if @tensuu <= $score
    self.next_scene = Title_Scene if @btn_back.pushed?
    exit if @btn_end.pushed?
    @gun.update
  end
  
  def render
    Window.draw(0,0,@image)
    @btn_back.render
    @btn_end.render
    @font_score.render
    @gun.render
  end
end
########################################################
########################################################
Scene.main_loop Title_Scene, FPS, 1
