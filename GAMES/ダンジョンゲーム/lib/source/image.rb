require 'dxruby'

class Images
  def initialize(x=0, y=0, w=50, h=50, string="", font_size=28, color=[255, 255, 255], st_color=[0, 0, 0])
    @x, @y    = x, y
    @w, @h    = w*$ratio_x, h*$ratio_y
    @string   = string
    @color    = color
    @st_color = st_color
    @image    = Image.new(@w,@h,@color)
    @font     = Font.new(font_size,"‚l‚r ‚oƒSƒVƒbƒN")
    @click    = 0
    @before_x,@before_y=nil,nil

    draw_string
    @image_pasting = :off
    
  end
  
  attr_accessor :color, :w, :h,:x,:y,:log_flag,:string,:font_size
  
  def string(string,font_size)
    @string = string
    @font = Font.new(font_size,"‚l‚r ‚oƒSƒVƒbƒN")
    size = @font.getWidth(@string)
    if @image_pasting == :off
    draw_string
    elsif @image_pasting == :on
    @image.drawFont(@w/(2*$ratio_x)-size/2, @h/(2*$ratio_y)-@font.size/2, @string, @font,[0,0,0])
    end
  end
  
  
  def string_pos(string,font_size,x,y,color)
    @string = string
    @font = Font.new(font_size,"‚l‚r ‚oƒSƒVƒbƒN")
    size = @font.getWidth(@string)
    @image.drawFont(x, y, @string, @font,color)
  end
  
  def waku(color, t=0)
    @image.box_fill(     0,     0, @w ,  t, color) #ã•Ó
    @image.box_fill(     0,     0,  t , @h, color) #¶•Ó
    @image.box_fill(@w-t-1,     0, @w , @h, color) #‰E•Ó
    @image.box_fill(     0,@h-t-1, @w , @h, color) #¶•Ó
  end

  def width(w)
    @image=Image.new(w,@h,@color)
  end
  
  def height(h)
    @image=Image.new(@w,h,@color)
  end
  
  def draw_string
    if @string.include?("\n")
      string_r = @string.split("\n")
      for i in 0..string_r.size-1
        size = @font.getWidth(string_r[i])#-@font.size/2
        @image.drawFont(@w/2-size/2, @h/2-(@font.size*string_r.size/2)+@font.size*i, string_r[i], @font, @st_color)
      end
    else
      size = @font.getWidth(@string)
      @image.drawFont(@w/2-size/2, @h/2-@font.size/2, @string, @font, @st_color)
    end
  end
  
  def font_color(color)
    size = @font.getWidth(@string)
    @image.drawFont(@w/2-size/2, @h/(2*$ratio_y)-@font.size/2, @string, @font,color)
  end
  
  def copy_image(x,y,image,x1,y1,im_w,im_h)
    Image.new(@w,@h,[255,255,255])
    #@image.setColorKey([255, 255, 255])
    @image.copyRect(x,y,image,x1,y1,im_w,im_h)
    draw_string
  end
  
  def image(filename)
    @image = Image.load(filename)
    #@image.setColorKey([255, 255, 255])
    @w = @image.width*$ratio_x
    @h = @image.height*$ratio_y
    size = @font.getWidth(@string)
    @image.drawFont(@w/(2*$ratio_x)-size/2, @h/(2*$ratio_y)-@font.size/2, @string, @font,[0,0,0])
    @image_pasting = :on
  end
  
  def image_split(filename,x,y)
    @image = Image.loadToArray(filename,x,y)
    #@image.setColorKey([255, 255, 255])
    @w = @image.width*$ratio_x
    @h = @image.height*$ratio_y
    draw_string
  end
  
  def image_sq=(imagename)
    imagess = imagename
    imagess.setColorKey([255, 255, 255])
    @w = @image.width*$ratio_x
    @h = @image.height*$ratio_y
    draw_string
  end
  
  def get_color(x,y)
    @image[x, y]
  end
  
  def save(name)
    @image.save(name)
  end
  
  def line(x1,y1,x2,y2,color=[0,0,0])
    @image.line(x1,y1,x2,y2,color)
  end
  
  def box(x1,y1,x2,y2,color=[0,0,0])
    @image.box(x1,y1,x2,y2,color)
  end
  
  def box_fill(x1, y1, x2, y2, color=[0,0,0])
    @image.boxFill(x1, y1, x2, y2, color)
  end
  
  def circlefill(x, y, r=3, color=[0,0,0])
    @image.circleFill(x, y, r, color)
  end
  
  def circle(x, y, r=3, color=[0,0,0])
    @image.circle(x, y, r, color)
  end
  
  def font(x,y,string="",size=10,color=[0,0,0])
    @image.drawFont(x,y,string, Font.new(size,"‚l‚r ‚oƒSƒVƒbƒN"),color)
  end
  
  def grid_make(xb,xt,yb,yt,canvas_w=700,canvas_h=700,color1=[210,210,210],color2=[0,0,0])
    x_num=(xb).abs+(xt).abs
    y_num=(yb).abs+(yt).abs
    math_w=canvas_w/x_num
    math_h=canvas_h/y_num
    for i in 0..x_num
      @image.line(math_w*i,0,math_w*i,@h,color1)#cƒ‰ƒCƒ“
    end
    for i in 0..y_num
      @image.line(0,math_h*i,@w,math_h*i,color1)#‰¡ƒ‰ƒCƒ“
    end
    @image.box(0,0,@w,@h,color2)#‰E‚Æ‰º‚ğ•`‰æ[”wŒi‚Æƒ‰ƒCƒ“‚ÌF‚ªˆÙ‚È‚éê‡
    zero_x =  math_w*(xb).abs
    zero_y =  math_h*(yt).abs
    #@image.circlefill(zero_x,zero_y,color2)#ƒ[ƒ“_
    @image.line(0,zero_y,@w,zero_y,color2)#x²
    @image.line(zero_x,0,zero_x,@h,color2)#y²
    @image.line(@w-math_w,zero_y-math_h,@w,zero_y,color2)#‚˜²–îˆó
    @image.line(@w-math_w,zero_y+math_h,@w,zero_y,color2)#‚˜²–îˆó
    @image.line(zero_x+math_w,math_h,zero_x,0,color2)#y²–îˆó
    @image.line(zero_x-math_w,math_h,zero_x,0,color2)#y²–îˆó
  end
  
  def pen_active(color=[0,0,0],size=3)
    mx = Input.mousePosX
    my = Input.mousePosY
    @click=1  if Input.mousePush?(M_LBUTTON)
    if Input.mouseDown?(M_LBUTTON)
      if mx >= @x and mx <= @x+@w and my >= @y and my <= @y+@h
        $file.puts "#{mx},#{my},#{$pen_count},#{$pen_size[$pen_count]},#{S_Timer.get}"
        if @before_x == nil or @before_y == nil
          @image.circleFill(mx - @x, my - @y, size, color)
        else
          for i in 0..size
            @image.line(@before_x-@x+i, @before_y-@y, mx-@x+i, my-@y, color)
            @image.line(@before_x-@x, @before_y-@y+i, mx-@x, my-@y+i, color)
            @image.line(@before_x-@x-i, @before_y-@y, mx-@x-i, my-@y, color)
            @image.line(@before_x-@x, @before_y-@y-i, mx-@x, my-@y-i, color)
            @image.circleFill(mx - @x, my - @y, size, color)
          end
        end
        @before_x=mx
        @before_y=my
      end
    else
      if @click==1
        @image.circleFill(mx - @x, my - @y, size, color)
        @before_x,@before_y=nil,nil
        @click=0
      end
    end
  end
  
  #•`‰æˆÊ’u‚Ìİ’è
  def set_pos(x, y)
    @x, @y = x, y
  end

  def color(color)
    @image=Image.new(@w,@h,color)
  end
  
  def setColorKey(color)
    @image.setColorKey(color)
  end
  
  def render
    if @image_pasting == :off
      Window.draw(@x, @y, @image)
    elsif @image_pasting == :on
      Window.draw_scale(@x, @y, @image,$ratio_x,$ratio_y,0,0)
    end
  end
  
  def scale_render(sx,sy)
    Window.draw_scale(@x, @y, @image,sx,sy,0,0)
  end
  
  def alpha_render(alpha)
    Window.drawAlpha(@x, @y, @image,alpha)
  end
  
  def rot_render(angle)
    Window.drawRot( @x, @y, @image, angle)
  end
end

class I_Timer
  def self.reset  #ŠÔ‚ğ‰Šú‰»
    @i_time = Time.now
  end

  def self.get  #Œo‰ßŠÔ‚ğ“¾‚é
    return Time.now - @i_time
  end 
end

class Array_Images
  def initialize(x,y,filename,x_count,y_count,n)
    @x,@y=x,y
    @x_count,@y_count=x_count,y_count
    @n=n
    @image=Image.loadToArray(filename,x_count,y_count )
  end
  attr_accessor :n, :x, :y
  
  def render
    Window.draw(@x, @y, @image[@n])
  end
  
  def scale_render(sx,sy)
    Window.draw_scale(@x, @y, @image[@n],sx,sy,0,0)
  end
  
  def rot_render(angle)
    Window.drawRot( @x, @y, @image[@n], angle)
  end
  
  def alpha_render(alpha)
    Window.drawAlpha(@x, @y, @image[@n], alpha) 
  end
end
