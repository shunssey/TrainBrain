class Button

  def initialize(string , x, y, w=120, h=60, font_size=40)
    #@image = Image.load("set_up/image2/button.bmp")
    @back_color = [220,220,220]
    @frame_color = [255,0,0]
    @font_color = [0,0,0]
    @image = Image.new(w,h,@frame_color)
    @image.boxFill(2,2,w-3,h-3,@back_color)
    @image.setColorKey([255, 255, 255])
    @x = x
    @y = y
    @w = @image.width
    @h = @image.height
    @string = string
    @mode = true
    #font_size = 28 if string.size >= 5
    #@font = Font.new(font_size)
    @font = Font.new(font_size,"桃花丸ゴシックL")
    #@sound = Sound.new("sound/push13.wav")    #プッシュ音
    draw_string
  end
  attr_accessor :x, :y, :image, :font
  attr_reader :w, :h, :string, :mode
  
  def image=(filename)
    tmp = Image.load(filename)
    @image = Image.new(tmp.width+6, tmp.height+6, @frame_color)
    @image.draw(3,3,tmp)
    #@image.setColorKey([0, 0, 0])
    @w = @image.width
    @h = @image.height
    #draw_string
  end
  
  def image2=(filename)
    @image = Image.load(filename)
    #@image.setColorKey([255, 255, 255])
    @w = 120
    @h = 120
    @scale = 120.0 / @image.width
    draw_string
  end
  
  def imageScale=(image)
    @image = image
    @w = 120
    @h = 120
    @scale = 120.0 / @image.width
    draw_string
  end
  
  def change_string=(string)
    @image.boxFill(2,2,@image.width-3,@image.height-3,@back_color)
    @string = string
    draw_string
  end
  
  def change_BackColor=(color)
    @back_color = color
    draw_string
  end
  
  def change_FrameColor=(color)
    @frame_color = color
    @image.boxFill(0,0,@image.width,@image.height,@frame_color)
    draw_string
  end
  
  def change_FontColor=(color)
    @font_color = color
    draw_string
  end
  
  def change_mode=(mode)
    @mode = mode
    if mode
      @font_color = @font_color0
    else
      @font_color0 = @font_color # 元の色を保存
      @font_color = [200,200,200]
    end
    draw_string
  end
  
  def draw_string
    size = @font.getWidth(@string)
    @image.boxFill(2,2,@image.width-3,@image.height-3,@back_color)
    @image.drawFont(@w/2-size/2, @h/2-@font.size/2, @string, @font,@font_color)
  end
  
  def load_push_sound(filename)
    @sound = Sound.new(filename)
  end
  
  def pushed?(mouse_x, mouse_y)
    if @mode
       if (mouse_x - @x)/@w.to_i == 0 and (mouse_y - @y)/@h.to_i == 0
         @sound.play if @sound   #効果音があればならす
         return true
       else
         return false
       end
    else
      return false
    end
  end
  
  def render
   #if @scale
   # Window.drawScale(@x,@y,@image,@scale,@scale,0,0)
   #else
    Window.draw(@x, @y, @image)
   #end
  end
end
