class PlayerMake_Scene < Init_Scene

  def init
    Input.mouseEnable=true
    @input_count = 0
    @font = Array.new
    @kana_render = nil
    @kana_select = Array.new
    if $flag_name_edit == :on
      @kana_select[0] = $player_name[0][0]
      @input_count = $player_name[0][0].split(//).size
    end
    keyboard_make
    @bg = Images.new(0,0, Black, 10, 10)
    @bg.image("lib/image/background/bg.png")
    @scene_name = Images.new(Window_w/2-250,0, Black, 10, 10)
    @scene_name.image("lib/image/plate/kanban.png")
    @player_image = Images.new(200,180, Black, 10, 10)
    @player_image.image("lib/image/plate/plate_2.png")
    @player_name = Images.new(500,280, White, 400, 120)
    @player_name.waku(Black)
    @font = Fonts.new("���O����͂��Ă�", 500 , 230, 40, Black)
    name_update
  end
  
  def keyboard_make
    @kana = [["��","��","��","��","��"],["��","��","��","��","��"],["��","��","��","��","��"],["��","��","��","��","��"], 
             ["��","��","��","��","��"],["��","��","��","��","��"],["��","��","��","��","��"],["��","�@","��","�@","��"],
             ["��","��","��","��","��"],["��","�@","��","�@","��"],["��","�@","��","�@","��"],["�@","�@","��","�@","�@"],
             ["��","��","��","��","��"],["��","��","��","��","��"],["��","��","��","��","��"],["��","��","��","��","��"],
             ["��","��","��","��","��"]]
    @btn_kettei = Button.new(900, 680, "����", 30, 110, 50, [120, 120, 120], [220,220,220], [70,70,70])
    @btn_reset = Button.new(600, 680, "���Z�b�g", 30, 110, 50, [120, 120, 120], [220,220,220], [70,70,70])
    @btn_itimoji = Button.new(450, 680, "�P��������", 20, 110, 50, [120, 120, 120], [220,220,220], [70,70,70])
    @btn = (0..17).map {Array.new(5)}
    for i in 0..16
      for j in 0..4
        @btn[i][j] = Button.new(962-i*60, 400+(j+1)*50, "#{@kana[i][j]}", 30, 60, 50, White, [220,220,220], [70,70,70], Black)
      end
    end
    
    @btn_ok = Button.new(800, 710, "����", 30, 150, 50, White, [220,220,220], [70,70,70], Black)
    @btn_reset = Button.new(600, 710, "���Z�b�g", 30, 150, 50, White, [220,220,220], [70,70,70], Black)
  end
  
  def name_update
    @kana_render = @kana_select.join
    @player_name = Images.new(500,280, White, 400, 120, "#{@kana_render}",80)
    @player_name.waku(Black)
  end
  
  def update
    if @input_count != 5
      for i in 0..16
        for j in 0..4
          if @btn[i][j].mousePushed?
            if @btn[i][j] != @btn[7][1]and @btn[i][j] != @btn[7][3]and @btn[i][j] != @btn[9][1] and @btn[i][j] != @btn[9][3]and @btn[i][j] != @btn[10][1] and @btn[i][j] != @btn[10][3]and @btn[i][j] != @btn[11][0]and @btn[i][j] != @btn[11][1]and @btn[i][j] != @btn[11][3] 
              @kana_select[@input_count]=@kana[i][j]
              @input_count += 1
              name_update
            end
          end
        end
      end
    end
    if @btn_ok.mousePushed?
      if $flag_name_edit == :off
        if @kana_render != ""
          new = ["#{@kana_render}","#{Time.now.strftime("%Y/%m/%d %H:%M.%S")}"]
          $player_name.unshift(new)
          File.open("player_data/player_list.txt","w") do |file|
            for i in 0..$player_name.size-1
              file.puts"#{$player_name[i][0]},#{$player_name[i][1]}"
            end
          end
        end
      elsif $flag_name_edit == :on
        $player_name[0][0] = @kana_render
        File.open("player_data/player_list.txt","w") do |file|
          for i in 0..$player_name.size-1
            file.puts"#{$player_name[i][0]},#{$player_name[i][1]}"
          end
        end
      end
      self.next_scene = Title_Scene
    elsif @btn_reset.mousePushed?
      @input_count = 0
      @kana_select = Array.new
      @player_name = Images.new(500,280, White, 400, 120)
      @player_name.waku(Black)
    elsif $btn_esc.mousePushed?
      exit
    elsif $btn_back.mousePushed?
      self.next_scene = Title_Scene
    end
  end
  
  def render
    @bg.render
    @scene_name.render
    @player_image.render
    @player_name.render
    @font.render
    for i in 0..16
      for j in 0..4
        @btn[i][j].render
      end
    end
    @btn_ok.render
    @btn_reset.render
    $btn_back.render
    $btn_esc.render
  end
  
end
