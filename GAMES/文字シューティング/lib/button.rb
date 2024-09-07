require 'dxruby'

class Button
  def initialize(x, y, string = "", font_size = 36, w = 40, h = 100, bk_color = [250, 0, 0], gr_color = [220,220,0], cg_color = [0,0,0], ft_color =[255,255,255])
    @x ,@y = x, y
    @w ,@h = w, h
    @color = bk_color
    @cg_color = cg_color
    @image = Image.new(@w, @h, @color)
    @gr_color = gr_color
    @ft_color = ft_color
    @image.box(0, 0, @w-1, @h-1, @gr_color)
    @string = string
    @font = Font.new(font_size,"HGê≥û≤èëëÃ-PRO")#English
    @sound = Sound.new("sound/push13.wav")    #ÉvÉbÉVÉÖâπ
    draw_string
    @click = 0
  end
  attr_accessor :x, :y, :string, :image, :font, :bc_color ,:gr_color,:cg_color,:cm_color
  
  def image=(filename)
    @image = Image.load(filename)
    @image.setColorKey([255,255,255])
    @w = @image.width
    @h = @image.height
    draw_string
  end
  
  def set_color(color)
    @image = Image.new(@w, @h, color)
    @image.box(0, 0,@w-1, @h-1, @gr_color)
    draw_string
  end
  
  def string=(string)
    @string = string
    draw_string
  end
  
  def draw_string
    size = @font.getWidth(@string)
    @image.drawFont(@w/2-size/2, @h/2-@font.size/2, @string, @font, @ft_color)
  end
  
  def load_push_sound(filename)
    @sound = Sound.new(filename)
  end
  
  def pushed?#(mouse_x, mouse_y)
    mouse_x = Input.mousePosX
    mouse_y = Input.mousePosY
    if Input.mousePush?(M_LBUTTON) and @click == 0
      if (mouse_x - @x)/@w == 0 and (mouse_y - @y)/@h == 0
        @sound.play if @sound   #å¯â âπÇ™Ç†ÇÍÇŒÇ»ÇÁÇ∑
        @image.box(0, 0,@w-1, @h-1, @cg_color)
        @click = 1
        return false
      end
    elsif Input.mouseDown?(M_LBUTTON) == false and @click == 1
      @image.box(0, 0,@w-1, @h-1, @gr_color)
      @click = 0
      return true
    else
      return false
    end
  end
  
  def render
    Window.draw(@x, @y, @image)
  end
end
