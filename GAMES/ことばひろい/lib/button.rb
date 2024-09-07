require 'dxruby'

class Button
  def initialize(x, y, string = "", font_size = 36, w = 40, h = 100, bk_color = [120, 120, 120], gr_color1 = [220,220,220],gr_color2 = [70,70,70])
    @x ,@y = x, y
    @w ,@h = w, h
    @color = bk_color
    @image = Image.new(@w, @h, @color)
    @gr_color1,@gr_color2 = gr_color1,gr_color2
    @image.box_fill(0, 0,@w , 3, @gr_color1)
    @image.box_fill(0, 0,3 , @h, @gr_color1)
    @image.box_fill(@w-3, 0,@w , @h, @gr_color2)
    @image.box_fill(0, @h-3,@w , @h, @gr_color2)
    @string = string
    @font = Font.new(font_size,"HGê≥û≤èëëÃ-PRO")
    #@sound = Sound.new("sound/push13.wav")    #ÉvÉbÉVÉÖâπ
    draw_string
    @click = 0
  end
  attr_accessor :x, :y, :string, :image, :font, :bc_color ,:gr_color1,:gr_color2
  
  def image=(filename)
    @image = Image.load(filename)
    #@image.setColorKey([255, 255, 255])
    @w = @image.width
    @h = @image.height
    draw_string
  end
  
  def set_color(color)
    @image = Image.new(@w, @h, color)
    @image.box_fill(0, 0,@w , 3, @gr_color1)
    @image.box_fill(0, 0,3 , @h, @gr_color1)
    @image.box_fill(@w-3, 0,@w , @h, @gr_color2)
    @image.box_fill(0, @h-3,@w , @h, @gr_color2)
    draw_string
  end
  
  def string=(string)
    @string = string
    draw_string
  end
  
  def draw_string
    size = @font.getWidth(@string)
    @image.drawFont(@w/2-size/2, @h/2-@font.size/2, @string, @font)
  end
  
  def load_push_sound(filename)
    #@sound = Sound.new(filename)
  end
  
  def pushed?#(mouse_x, mouse_y)
    mouse_x = Input.mousePosX
    mouse_y = Input.mousePosY
    if Input.mousePush?(M_LBUTTON) and @click == 0
      if (mouse_x - @x)/@w == 0 and (mouse_y - @y)/@h == 0
        #@sound.play if @sound   #å¯â âπÇ™Ç†ÇÍÇŒÇ»ÇÁÇ∑
        @image.box_fill(0, 0,@w , 3, @gr_color2)
        @image.box_fill(0, 0,3 , @h, @gr_color2)
        @image.box_fill(@w-3, 0,@w , @h, @gr_color1)
        @image.box_fill(0, @h-3,@w , @h, @gr_color1)
        @click = 1
        return false
      end
    elsif Input.mouseDown?(M_LBUTTON) == false and @click == 1
      @image.box_fill(0, 0,@w , 3, @gr_color1)
      @image.box_fill(0, 0,3 , @h, @gr_color1)
      @image.box_fill(@w-3, 0,@w , @h, @gr_color2)
      @image.box_fill(0, @h-3,@w , @h, @gr_color2)
      @click = 0
      return true if (mouse_x - @x)/@w == 0 and (mouse_y - @y)/@h == 0
    else
      return false
    end
  end
  
  def render
    Window.draw(@x, @y, @image)
  end
end
