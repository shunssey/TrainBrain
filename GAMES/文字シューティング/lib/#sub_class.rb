
class Gun_cursor
  def initialize
    @image = Image.load("image/scoop_new.png", 0, 0, 100, 100)
    Input.mouseEnable=false
    @sound = Sound.new("sound/Gun_shot.wav")
    @sound.setVolume(200)
    Input.setMousePos(512, 384)
  end
  
  def update
    @x, @y = Input.mousePosX, Input.mousePosY
    @sound.play if Input.mousePush?(M_LBUTTON)
  end
  
  def x
    return @x
  end
  
  def y
    return @y
  end
  
  def render
    Window.draw(@x-50,@y-50,@image)
  end
end


class Baloon
  def initialize(x=0,y=0,font=nil,num=nil,geki=0)
    @image = Image.load("image/baloon.png", 0, 0) 
    @image_hole = Image.load("image/hole.png", 0, 0) 
    @x = x
    @xx = x
    @y = y
    @w, @h = @image.width, @image.height
    @font = font
    @num = num
    @geki = geki
    
    @count = 0
    @switch = :up
    @font_size = Font.new(72)
    p @w/2 - @font_size.getWidth(@font)
    @image.drawFont(@w/2 - @font_size.getWidth(@font)/2,15,"#{@font}",@font_size,Black)
    @click = 0
    @rand = (rand(5)-1)*0.1
    
    if geki == 1
      @x, @y = 0, 768
    end
    
  end
  
  def x
    return @x
  end
  
  def y
    return @y
  end
  
  def font
    return @font
  end
  
  def update
    #motion_fuwafuwa
    @y -= 0.7333#1.0=15•b,0.5=30•b
    @count += 0.5
    if @switch == :up
      @switch = :down if @count%50 == 0
    elsif @switch == :down
      @switch = :up if @count%50 == 0
    end
    
    if @num%2 == 0
    @xx -= @rand if @switch == :up
    @xx += @rand if @switch == :down
    elsif @num%2 != 0
    @xx += @rand if @switch == :up
    @xx -= @rand if @switch == :down
    end
  end
  
  def motion_fuwafuwa
    @count += 0.6
    if @switch == :up
      @switch = :down if @count%50 == 0
    elsif @switch == :down
      @switch = :up if @count%50 == 0
    end
    
    #if @num%2 == 0
    #@y -= 0.5 if @switch == :up
    #@y += 0.5 if @switch == :down
    #elsif @num%2 != 0
    #@y += 0.5 if @switch == :up
    #@y -= 0.5 if @switch == :down
    #end
  end
  
  def pushed?#(mouse_x, mouse_y)
    mouse_x = Input.mousePosX
    mouse_y = Input.mousePosY
    if Input.mousePush?(M_LBUTTON) and @click == 0
      if (mouse_x - @x)/@w == 0 and ((mouse_y - @y)/@h).round == 0
        @click = 1
        return false
      end
    elsif Input.mouseDown?(M_LBUTTON) == false and @click == 1
      @click = 0
      return true
    else
      return false
    end
    
  end
  
  def string=(string)
    @string = string
    draw_string
  end
  
  def draw_string
    size = @font.getWidth(@string)
    @image.drawFont(@w/2-size/2, @h/2-@font.size/2, @string, @font)
  end
  
  def render
    Window.draw(@xx,@y,@image) if @geki == 0
    Window.draw(@xx,@y,@image_hole) if @click == 1
  end
end
