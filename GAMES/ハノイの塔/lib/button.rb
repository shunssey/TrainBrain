require 'dxruby'

class Button
  def initialize(x, y, string = "", font_size = 36, w = 40, h = 100, bk_color = [120, 120, 120], gr_color1 = [220,220,220],gr_color2 = [70,70,70],mg_color=[255,255,255])
    @x ,@y = x, y
    @w ,@h = w, h
    @color = bk_color
    @mg_color=mg_color
    @image = Image.new(@w, @h, @color)
    @gr_color1,@gr_color2 = gr_color1,gr_color2
    @image.box_fill(0, 0,@w , 2, @gr_color1)
    @image.box_fill(0, 0,2 , @h, @gr_color1)
    @image.box_fill(@w-2, 0,@w , @h, @gr_color2)
    @image.box_fill(0, @h-2,@w , @h, @gr_color2)
    @string = string
    @font = Font.new(font_size,"ÇlÇr ÇoÉSÉVÉbÉN")
    draw_string
    @click = 0
    @scale_w = 1
    @scale_h = 1
  end
  attr_accessor :x, :y, :string, :image, :font, :bc_color ,:gr_color1,:gr_color2,:w, :h
  
  def image(filename)
    @image = Image.load(filename)
    @image.setColorKey([255, 255, 255])
    @w = @image.width
    @h = @image.height
    draw_string
  end
  
  #ï`âÊà íuÇÃê›íË
  def set_pos(x, y)
    @x, @y = x, y
  end
  
  def color(color)
    @image = Image.new(@w, @h, color)
    @image.box_fill(0, 0,@w , 2, @gr_color1)
    @image.box_fill(0, 0,2 , @h, @gr_color1)
    @image.box_fill(@w-2, 0,@w , @h, @gr_color2)
    @image.box_fill(0, @h-2,@w , @h, @gr_color2)
    draw_string
  end
  
  def font(x,y,string="",size=10,color=[0,0,0])
    @image.drawFont(x,y,string, Font.new(size,"HGê≥û≤èëëÃ-PRO"),@mg_color)
  end
  
  def string(string,mg_color=[255,255,255])
    @image = Image.new(@w, @h, @color)
    @image.box_fill(0, 0,@w , 2, @gr_color1)
    @image.box_fill(0, 0,2 , @h, @gr_color1)
    @image.box_fill(@w-2, 0,@w , @h, @gr_color2)
    @image.box_fill(0, @h-2,@w , @h, @gr_color2)
    @mg_color=mg_color
    @string = string
    draw_string
  end
  
  def line(x1,y1,x2,y2,color=[0,0,0])
    @image.line(x1,y1,x2,y2,color)
  end
  
  def circle(x, y, r=3, color=[0,0,0])
    @image.circle(x, y, r, color)
  end
  
  def circle_fill(x, y, r=3, color=[0,0,0])
    @image.circleFill(x, y, r, color)
  end
  
  def draw_string
    size = @font.getWidth(@string)
    @image.drawFont(@w/2-size/2, @h/2-@font.size/2, @string, @font,@mg_color)
  end
  
  def waku(color)
    @image.box(0,0,@w,@h,color)
  end
  
  def load_push_sound(filename)
    @sound = Sound.new(filename)
  end
  
  def old_pushed?#(mouse_x, mouse_y)
    mouse_x = Input.mousePosX
    mouse_y = Input.mousePosY
    if Input.mousePush?(M_LBUTTON) and @click == 0
      #if (mouse_x - @x)/(@w*@scale_w) == 0 and (mouse_y - @y)/(@h*@scale_h) == 0
    if (@x..@x+@w).include?(mouse_x)
      if (@y..@y+@h).include?(mouse_y)
        #$sound.play if $sound   #å¯â âπÇ™Ç†ÇÍÇŒÇ»ÇÁÇ∑
        @image.box_fill(0, 0,@w , 3, @gr_color2)
        @image.box_fill(0, 0,3 , @h, @gr_color2)
        @image.box_fill(@w-3, 0,@w , @h, @gr_color1)
        @image.box_fill(0, @h-3,@w , @h, @gr_color1)
        @click = 1
        return false
        #return true
      end
     end
    elsif Input.mouseDown?(M_LBUTTON) == false and @click == 1
      @image.box_fill(0, 0,@w , 3, @gr_color1)
      @image.box_fill(0, 0,3 , @h, @gr_color1)
      @image.box_fill(@w-3, 0,@w , @h, @gr_color2)
      @image.box_fill(0, @h-3,@w , @h, @gr_color2)
      @click = 0
      return true if (mouse_x - @x*@scale_w)/@w*@scale_w == 0 and (mouse_y - @y*@scale_h)/@h*@scale_h == 0#(mouse_x - @x)/@w == 0 and (mouse_y - @y)/@h == 0
      #return false
    else
      return false
    end
  end
  
  def pushed?#(mouse_x, mouse_y)
    mouse_x = Input.mousePosX
    mouse_y = Input.mousePosY
    if Input.mousePush?(M_LBUTTON) and @click == 0
      #if (mouse_x - @x)/(@w*@scale_w) == 0 and (mouse_y - @y)/(@h*@scale_h) == 0
      if ((@x)..(@x+@w-(@w)*(1-@scale_w))).include?(mouse_x) and ((@y)..(@y+@h-(@h)*(1-@scale_h))).include?(mouse_y)
        #$sound.play if $sound   #å¯â âπÇ™Ç†ÇÍÇŒÇ»ÇÁÇ∑
        @image.box_fill(0, 0,@w , 2, @gr_color2)
        @image.box_fill(0, 0,2 , @h, @gr_color2)
        @image.box_fill(@w-2, 0,@w , @h, @gr_color1)
        @image.box_fill(0, @h-2,@w , @h, @gr_color1)
        @click = 1
        return false
        #return true
      end
    elsif Input.mouseDown?(M_LBUTTON) == false and @click == 1
      @image.box_fill(0, 0,@w , 2, @gr_color1)
      @image.box_fill(0, 0,2 , @h, @gr_color1)
      @image.box_fill(@w-2, 0,@w , @h, @gr_color2)
      @image.box_fill(0, @h-2,@w , @h, @gr_color2)
      @click = 0
      return true if ((@x)..(@x+@w-(@w)*(1-@scale_w))).include?(mouse_x) and ((@y)..(@y+@h-(@h)*(1-@scale_h))).include?(mouse_y)#(mouse_x - @x)/@w == 0 and (mouse_y - @y)/@h == 0#(mouse_x - @x)/@w == 0 and (mouse_y - @y)/@h == 0
      #return false
    else
      return false
    end
  end
  
  def pushedImage?#(mouse_x, mouse_y)
    mouse_x = Input.mousePosX
    mouse_y = Input.mousePosY
    if Input.mousePush?(M_LBUTTON) and @click == 0
      #if (mouse_x - @x)/(@w*@scale_w) == 0 and (mouse_y - @y)/(@h*@scale_h) == 0
      if ((@x)..(@x+@w-(@w)*(1-@scale_w))).include?(mouse_x) and ((@y)..(@y+@h-(@h)*(1-@scale_h))).include?(mouse_y)
        #$sound.play if $sound   #å¯â âπÇ™Ç†ÇÍÇŒÇ»ÇÁÇ∑
        #@image.box(0,0,@w,@h,[255,100,100])
        @click = 1
        return false
        #return true
      end
    elsif Input.mouseDown?(M_LBUTTON) == false and @click == 1
      #@image.box(0,0,@w,@h,[255,255,255,255])
      @click = 0
      return true if ((@x)..(@x+@w-(@w)*(1-@scale_w))).include?(mouse_x) and ((@y)..(@y+@h-(@h)*(1-@scale_h))).include?(mouse_y)#(mouse_x - @x)/@w == 0 and (mouse_y - @y)/@h == 0#(mouse_x - @x)/@w == 0 and (mouse_y - @y)/@h == 0
      #return false
    else
      return false
    end
  end
  
  def pushedFormula?#(mouse_x, mouse_y)
    mouse_x = Input.mousePosX
    mouse_y = Input.mousePosY
    if Input.mousePush?(M_LBUTTON) and @click == 0
      #if (mouse_x - @x)/(@w*@scale_w) == 0 and (mouse_y - @y)/(@h*@scale_h) == 0
      if ((@x)..(@x+@w-(@w)*(1-@scale_w))).include?(mouse_x) and ((@y)..(@y+@h-(@h)*(1-@scale_h))).include?(mouse_y)
        #$sound.play if $sound   #å¯â âπÇ™Ç†ÇÍÇŒÇ»ÇÁÇ∑
        @image.box(0,0,@w,@h,[255,100,100])
        @click = 1
        return false
        #return true
      end
    elsif Input.mouseDown?(M_LBUTTON) == false and @click == 1
      @image.box(0,0,@w,@h,[255, 183, 76])
      @click = 0
      return true if ((@x)..(@x+@w-(@w)*(1-@scale_w))).include?(mouse_x) and ((@y)..(@y+@h-(@h)*(1-@scale_h))).include?(mouse_y)#(mouse_x - @x)/@w == 0 and (mouse_y - @y)/@h == 0#(mouse_x - @x)/@w == 0 and (mouse_y - @y)/@h == 0
      #return false
    else
      return false
    end
  end
  
  def pushed2?#(mouse_x, mouse_y)
    mouse_x = Input.mousePosX
    mouse_y = Input.mousePosY
    if Input.mousePush?(M_LBUTTON) and @click == 0
      #if (mouse_x - @x)/(@w*@scale_w) == 0 and (mouse_y - @y)/(@h*@scale_h) == 0
      if ((@x)..(@x+@w-(@w)*(1-@scale_w))).include?(mouse_x) and ((@y)..(@y+@h-(@h)*(1-@scale_h))).include?(mouse_y)
        #$sound.play if $sound   #å¯â âπÇ™Ç†ÇÍÇŒÇ»ÇÁÇ∑
        @image.box_fill(0, 0,@w , 5, [255,204,204])
        @image.box_fill(0, 0,5 , @h, [255,204,204])
        @image.box_fill(@w-5, 0,@w , @h, [255,204,204])
        @image.box_fill(0, @h-5,@w , @h, [255,204,204])
        @click = 1
        return false
        #return true
      end
    elsif Input.mouseDown?(M_LBUTTON) == false and @click == 1
      @image.box_fill(0, 0,@w , 5, [255,0,0])
      @image.box_fill(0, 0,5 , @h, [255,0,0])
      @image.box_fill(@w-5, 0,@w , @h, [255,0,0])
      @image.box_fill(0, @h-5,@w , @h, [255,0,0])
      @click = 0
      return true if ((@x)..(@x+@w-(@w)*(1-@scale_w))).include?(mouse_x) and ((@y)..(@y+@h-(@h)*(1-@scale_h))).include?(mouse_y)#(mouse_x - @x)/@w == 0 and (mouse_y - @y)/@h == 0#(mouse_x - @x)/@w == 0 and (mouse_y - @y)/@h == 0
      #return false
    else
      return false
    end
  end
  
  def pushedDrag?(mouse_x, mouse_y)
    if Input.mousePush?(M_LBUTTON)
      if (mouse_x - @x)/@w == 0 and (mouse_y - @y)/@h == 0 and @click ==0
        #$sound.play if $sound   #å¯â âπÇ™Ç†ÇÍÇŒÇ»ÇÁÇ∑
        @click=1
        @x = mouse_x-@w/2
        @y = mouse_y-@h/2
        return false
      end
    elsif Input.mouseDown?(M_LBUTTON)==false
      @click=0
    end
    if @click==1
      #@x = mouse_x-@w/2
      #@y = mouse_y-@h/2
      #@image.box(0,0,@w,@h,Red)
      return true
    else
      #@image.box(0,0,@w,@h,[0,0,0,0])
      return false
    end
  end
  
  def render
    Window.draw(@x, @y, @image)
  end
  
  def render_scale(scale_w, scale_h)
    @scale_w = scale_w
    @scale_h = scale_h
    Window.drawScale(@x-(@w)*(1-@scale_w)/2, @y-(@h)*(1-@scale_h)/2, @image, @scale_w, @scale_h)
  end
  
  def render_rot(angle)
    Window.drawRot( @x, @y, @image, angle)
  end
  
  def renderAlpha(alpha)
    Window.drawAlpha(@x, @y, @image, alpha) 
  end
  
  def futowaku(color,a)
    for i in 0..a-1
      @image.box(0+i,0+i,@w-i-1,@h-i-1,color)
    end
  end
end
