require 'dxruby'

class Button
  def initialize(x, y, w=40, h=100, string="", font_size=36, color=[120,120,120], st_color=[255,255,255], gr_color1=[220,220,220], gr_color2=[70,70,70])
    @x, @y    = x, y
    @w, @h    = w*$ratio_x, h*$ratio_y
    @string   = string
    @color    = color
    @st_color = st_color
    @image    = Image.new(@w, @h, @color)
    @font     = Font.new(font_size,"MSPゴシック")
    @click    = 0
    
    @gr_color1, @gr_color2 = gr_color1, gr_color2
    @image.box_fill(   0,    0, @w ,  2, @gr_color1)
    @image.box_fill(   0,    0,  2 , @h, @gr_color1)
    @image.box_fill(@w-2,    0, @w , @h, @gr_color2)
    @image.box_fill(   0, @h-2, @w , @h, @gr_color2)
    draw_string
    
    @image_pasting = :off
  end
  attr_accessor :x, :y, :w, :h, :string, :image, :font, :bc_color ,:gr_color1,:gr_color2
  
  def image(filename)
    @image = Image.load(filename)
    #@image.setColorKey([255, 255, 255])
    @w = @image.width*$ratio_x
    @h = @image.height*$ratio_y
    size = @font.getWidth(@string)
    @image.drawFont(@w/(2*$ratio_x)-size/2, @h/(2*$ratio_y)-@font.size/2, @string, @font,@st_color)
    @image_pasting = :on
  end
  
  def image_sq=(filename)
    @image = filename
    @image.setColorKey([255, 255, 255])
    @w = @image.width
    @h = @image.height
    draw_string
  end
  
  def waku(color, t=0)
    @image.box_fill(     0,     0, @w ,  t, color) #上辺
    @image.box_fill(     0,     0,  t , @h, color) #左辺
    @image.box_fill(@w-t-1,     0, @w , @h, color) #右辺
    @image.box_fill(     0,@h-t-1, @w , @h, color) #左辺
  end
  
  def circle(x, y, r=3, color=[0,0,0])
    @image.circle(x, y, r, color)
  end
  
  #描画位置の設定
  def set_pos(x, y)
    @x, @y = x, y
  end
  
  def color(color)
    @image = Image.new(@w, @h, color)
    @image.box_fill(   0,    0, @w ,  2, @gr_color1)
    @image.box_fill(   0,    0,  2 , @h, @gr_color1)
    @image.box_fill(@w-2,    0, @w , @h, @gr_color2)
    @image.box_fill(   0, @h-2, @w , @h, @gr_color2)
    draw_string
  end
  
  def font_color(color)
    @st_color = color
    size = @font.getWidth(@string)
    @image.drawFont(@w/(2*$ratio_x)-size/2, @h/(2*$ratio_y)-@font.size/2, @string, @font,@st_color)
  end
  
  def string(string,font_size)
    @string = string
    @font = Font.new(font_size,"MSPゴシック")
    size = @font.getWidth(@string)
    if @image_pasting == :off
      draw_string
    elsif @image_pasting == :on
      @image.drawFont(@w/(2*$ratio_x)-size/2, @h/(2*$ratio_y)-@font.size/2, @string, @font,@st_color)
    end
    
  end
  
  def draw_string
    size = @font.getWidth(@string)
    @image.drawFont(@w/2-size/2, @h/(2*$ratio_y)-@font.size/2, @string, @font,@st_color)
  end
  
  def load_push_sound(filename)
    @sound = Sound.new(filename)
  end
    
  def render  #ボタンの描画処理
    if @image_pasting == :off
      Window.draw(@x, @y, @image)
    elsif @image_pasting == :on
      Window.draw_scale(@x, @y, @image,$ratio_x,$ratio_y,0,0)
    end
  end
  
  def pushed? #ボタンを押下した時の処理
    mouse_x = Input.mousePosX
    mouse_y = Input.mousePosY
    if Input.mousePush?(M_LBUTTON) and @click == 0
      if mouse_x >= @x and mouse_x <= @x+@w and mouse_y >= @y and mouse_y <= @y+@h
        $sound.play if $sound   #効果音があればならす
        @image.box_fill(   0,    0, @w ,  2, @gr_color2)
        @image.box_fill(   0,    0,  2 , @h, @gr_color2)
        @image.box_fill(@w-2,    0, @w , @h, @gr_color1)
        @image.box_fill(   0, @h-2, @w , @h, @gr_color1)
        @click = 1
        return false
        #return true
      end
    elsif Input.mouseDown?(M_LBUTTON) == false and @click == 1
      @image.box_fill(   0,    0, @w ,  2, @gr_color1)
      @image.box_fill(   0,    0,  2 , @h, @gr_color1)
      @image.box_fill(@w-2,    0, @w , @h, @gr_color2)
      @image.box_fill(   0, @h-2, @w , @h, @gr_color2)
      @click = 0
      return true if mouse_x >= @x and mouse_x <= @x+@w and mouse_y >= @y and mouse_y <= @y+@h
      #return false
    else
      return false
    end
  end
  
  def pushed2? #ボタンを押下した時の処理
    mouse_x = Input.mousePosX
    mouse_y = Input.mousePosY
    if Input.mousePush?(M_LBUTTON) and @click == 0
      if mouse_x >= @x and mouse_x <= @x+@w and mouse_y >= @y and mouse_y <= @y+@h
        $sound.play if $sound   #効果音があればならす
        #@btn.image("./image/pipo-WindowBaseSet2a_01.png")
        p 123
        #@image.box_fill(   0,    0, @w ,  2, @gr_color2)
        #@image.box_fill(   0,    0,  2 , @h, @gr_color2)
        #@image.box_fill(@w-2,    0, @w , @h, @gr_color1)
        #@image.box_fill(   0, @h-2, @w , @h, @gr_color1)
        @click = 1
        return false
        #return true
      end
    elsif Input.mouseDown?(M_LBUTTON) == false and @click == 1
      p 456
      #@image.box_fill(   0,    0, @w ,  2, @gr_color1)
      #@image.box_fill(   0,    0,  2 , @h, @gr_color1)
      #@image.box_fill(@w-2,    0, @w , @h, @gr_color2)
      #@image.box_fill(   0, @h-2, @w , @h, @gr_color2)
      @click = 0
      return true if mouse_x >= @x and mouse_x <= @x+@w and mouse_y >= @y and mouse_y <= @y+@h
      #return false
    else
      return false
    end
  end
  
  #山岡追加（2015_0303）
  def pushedDrag? #ボタンをドラッグした時の処理
    mouse_x = Input.mousePosX
    mouse_y = Input.mousePosY
    if Input.mousePush?(M_LBUTTON)
      if mouse_x >= @x and mouse_x <= @x+@w and mouse_y >= @y and mouse_y <= @y+@h and @click ==0
        $sound.play if $sound   #効果音があればならす
        @x      = mouse_x - @w/2
        @y      = mouse_y - @h/2
        @click  = 1
        return false
      end
    elsif Input.mouseDown?(M_LBUTTON)==false
      @click = 0
    end
    if @click == 1
      #@x = mouse_x-@w/2
      #@y = mouse_y-@h/2
      #@image.box(0,0,@w,@h,Red)
      return true
    else
      #@image.box(0,0,@w,@h,[0,0,0,0])
      return false
    end
  end
  
  #加藤追加（2015_0825）
  def mouse_on? #ボタンにマウスカーソルが乗った時の処理
    mouse_x = Input.mousePosX
    mouse_y = Input.mousePosY
    if mouse_x >= @x and mouse_x <= @x+@w and mouse_y >= @y and mouse_y <= @y+@h
      return true
    else
      return false
    end
  end
  
end

  
