require 'dxruby'
#��{Image�N���X+�L�����o�X���Ċ���
class Images
  attr_accessor :color, :w, :h,:x,:y,:log_flag,:string,:font_size
  def initialize(x,y,color=[255,255,255],w=50,h=50,string="",font_size=32,log_flag=0)
    @x,@y=x,y
    @w,@h=w,h
    @color=color
    @image=Image.new(@w,@h,@color)
    @string = string
    @font = Font.new(font_size,"HG��������-PRO")
    @log_flag=log_flag
    @before_x,@before_y=nil,nil
    @click=0
    if log_flag==1
      @judge=Array.new()#����݂̂ł�
      @pen_array=Array.new
      @push=0
      I_Timer.reset
    end
    draw_string
  end
  
  def string=(string)
    @string = string
    draw_string
  end
  
  def waku(color)
    @image.box(0,0,@w,@h,color)
  end
  
  def draw_string
    size = @font.getWidth(@string)
    @image.drawFont(@w/2-size/2, @h/2-@font.size/2, @string, @font)
  end
  
  def copy_image(x,y,image,x1,y1,im_w,im_h)
    Image.new(@w,@h,[255,255,255])
    @image.setColorKey([255, 255, 255])
    @image.copyRect(x,y,image,x1,y1,im_w,im_h)
    draw_string
  end
  
  def image=(filename)
    @image = Image.load(filename)
    #@image.setColorKey([255, 255, 255])
    @w = @image.width
    @h = @image.height
    draw_string
  end
  
  def save=(name)
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
  
  def font(x,y,string="",size=10,color=[0,0,0])
    @image.drawFont(x,y,string, Font.new(size,"HG��������-PRO"),color)
  end
  
  def grid_make(xb,xt,yb,yt,canvas_w=700,canvas_h=700,color1=[210,210,210],color2=[0,0,0])
    x_num=(xb).abs+(xt).abs
    y_num=(yb).abs+(yt).abs
    math_w=canvas_w/x_num
    math_h=canvas_h/y_num
    for i in 0..x_num
      @image.line(math_w*i,0,math_w*i,@h,color1)#�c���C��
    end
    for i in 0..y_num
      @image.line(0,math_h*i,@w,math_h*i,color1)#�����C��
    end
    @image.box(0,0,@w,@h,color2)#�E�Ɖ���`��[�w�i�ƃ��C���̐F���قȂ�ꍇ
    zero_x =  math_w*(xb).abs
    zero_y =  math_h*(yt).abs
=begin
    #@image.circlefill(zero_x,zero_y,color2)#�[���_
    @image.line(0,zero_y,@w,zero_y,color2)#x��
    @image.line(zero_x,0,zero_x,@h,color2)#y��
    @image.line(@w-math_w,zero_y-math_h,@w,zero_y,color2)#�������
    @image.line(@w-math_w,zero_y+math_h,@w,zero_y,color2)#�������
    @image.line(zero_x+math_w,math_h,zero_x,0,color2)#y�����
    @image.line(zero_x-math_w,math_h,zero_x,0,color2)#y�����
=end
  end
  
  def pen_active(color=[0,0,0],size=3)
    mx = Input.mousePosX
    my = Input.mousePosY
    if @log_flag==1
      if Input.mousePush?(M_LBUTTON)
        if (mx - @x)/@w == 0 and (my - @y)/@h == 0
          @push+=1
          @click=1
          @before_x,@before_y=nil,nil
          #@image.circleFill(mx - @x, my - @y, size, color)
          #@pen_array.push([@push,mx-@x,my-@y,size,color,I_Timer.get])if @log_flag==1
        end
      end
    end
    if Input.mouseDown?(M_LBUTTON)#�ʏ�͂�������g�p
      if (mx - @x)/@w == 0 and (my - @y)/@h == 0
        if @before_x == nil or  @before_y == nil
          @image.circleFill(mx - @x, my - @y, size, color)
        else
          for i in 0..size
            @image.line(@before_x-@x+i, @before_y-@y, mx-@x+i, my-@y, color)
            @image.line(@before_x-@x, @before_y-@y+i, mx-@x, my-@y+i, color)
            @image.line(@before_x-@x-i, @before_y-@y, mx-@x-i, my-@y, color)
            @image.line(@before_x-@x, @before_y-@y-i, mx-@x, my-@y-i, color)
          end
        end
        @pen_array.push([@push,mx,my,size,color,I_Timer.get])if @log_flag==1
        @before_x=mx
        @before_y=my
      end
    else
      if @click==1
        @image.circleFill(mx - @x, my - @y, size, color)
        @click=0
      end
    end
  end
  
  #def pen_active2(color=[0,0,0],size=3,x_num,y_num,math_w,math_h)
  def pen_active2(color,size,x_num ,y_num ,math_w ,math_h,aa,bb)#���ڂ����蔻��t��
    mx = Input.mousePosX
    my = Input.mousePosY
    if @log_flag==1
      if Input.mousePush?(M_LBUTTON)
        if (mx - @x)/@w == 0 and (my - @y)/@h == 0
          for i in 0..x_num
            for j in 0..y_num
              if (mx-@x-math_w*i+aa/2)/aa==0  and (my-@y-math_h*j+bb/2)/bb==0
                @push+=1
                @image.circleFill(math_w*i, math_h*j, size, color)
                @pen_array.push([@push,math_w*i,math_h*j,size,color,I_Timer.get])if @log_flag==1
                @judge.push([i,j])
              end
            end
          end
        end
      end
    end
=begin
    if Input.mouseDown?(M_LBUTTON)#�ʏ�͂�������g�p
      if (mx - @x)/@w == 0 and (my - @y)/@h == 0
        @image.circleFill(mx - @x, my - @y, size, color)
        @pen_array.push([@push,mx,my,size,color,I_Timer.get])if @log_flag==1
      end
    end
=end
  end

  def judge
    return  @judge
  end
  
  def log
    return @pen_array if @log_flag==1#�G���[�h�~
  end
  
  #�`��ʒu�̐ݒ�
  def set_pos(x, y)
    @x, @y = x, y
  end

  def color(color)
    @image=Image.new(@w,@h,color)
  end
  
  def render
    Window.draw(@x, @y, @image)
  end
  
  def scale_render(sx,sy)
    Window.draw_scale(@x, @y, @image,sx,sy,0,0)
  end
end

class I_Timer
  def self.reset  #���Ԃ�������
    @i_time = Time.now
  end

  def self.get  #�o�ߎ��Ԃ𓾂�
    return Time.now - @i_time
  end 
end
