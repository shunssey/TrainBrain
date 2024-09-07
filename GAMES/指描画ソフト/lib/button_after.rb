require 'sdl'
require 'nkf'

#����̃{�^���N���X
#10.01.19 ����
#�^�u���b�gPC�ł̓��삪�������߃{�^�����������u�ԓ��삷��悤�ɕύX
#
class Button
  
  def initialize(string, x, y, width=60, height=60, font_size=20)
    SDL::TTF.init                                                        #TTF�̏�����
    @font_size = font_size
    @font = SDL::TTF.open("C:/WINDOWS/Fonts/MSGOTHIC.TTC", @font_size)        #�f�t�H���g�ŃV�X�e���t�H���gMS�S�V�b�N���g�p
    @font.style = SDL::TTF::STYLE_NORMAL
    @str_size = string.size
    @string = NKF.nkf('-w', string)
    @x, @y = x, y
    @width, @height = width, height
    @color = [220, 220, 220]
    
    @base_up = SDL::Surface.new(SDL::SRCALPHA, @width+3, @height+3, 32, 0x000000ff, 0x0000ff00, 0x00ff0000, 0xff000000)
    @base_up.fill_rect(0, 0, @width+3, @height+3, [0, 0, 0])
    @base_up.fill_rect(0, 0, @width, @height, @color)
    @base_up.draw_rect(0, 0, @width, @height, [0, 0, 150])
    @base_up.draw_rect(1, 1, @width-1, @height-1, [255, 255, 255])
    @font.draw_solid_utf8(@base_up, @string, (@width/2)-(@str_size/2)*(@font_size/2), (@height/2)-(@font_size/2), 0, 0, 0)        #TTF�`��
    
    @base_down = SDL::Surface.new(SDL::SRCALPHA, @width+3, @height+3, 32, 0x000000ff, 0x0000ff00, 0x00ff0000, 0xff000000)    
    @base_down.fill_rect(1, 1, @width+2, @height+2, [0, 0, 0])
    @base_down.fill_rect(2, 2, @width, @height, @color)
    @base_down.draw_rect(2, 2, @width, @height, [0, 0, 255])
    @base_down.draw_rect(3, 3, @width-2, @height-2, [255, 255, 255])
    @font.draw_solid_utf8(@base_down, @string, (@width/2)-(@str_size/2)*(@font_size/2)+2, (@height/2)-(@font_size/2)+2, 0, 0, 0)        #TTF�`��
    @pushed = false
    @pressed = false
  end
  
  attr_accessor :x, :y, :width, :height  #���C�����[�v�̑O�ɐݒ肷��
  
  def set_size(width, height)
    @width = width
    @height = height
    @base = SDL::Surface.new(SDL::SRCALPHA, @width+3, @height+3, 32, 0x000000ff, 0x0000ff00, 0x00ff0000, 0xff000000)
  end
  
  def draw_image(fname)
    @image = SDL::Surface.load(fname)
    @width = @image.w
    @height = @image.h
    
    @base_up = SDL::Surface.new(SDL::SRCALPHA, @width+3, @height+3, 32, 0x000000ff, 0x0000ff00, 0x00ff0000, 0xff000000)
    @base_up.fill_rect(0, 0, @width+3, @height+3, [0, 0, 0])
    @base_up.put(@image, 0, 0)
    @base_up.draw_rect(0, 0, @width, @height, [0, 0, 150])
    @base_up.draw_rect(1, 1, @width-1, @height-1, [255, 255, 255])
    @font.draw_solid_utf8(@base_up, @string, (@width/2)-(@str_size/2)*(@font_size/2), (@height/2)-(@font_size/2), 0, 0, 0)        #TTF�`��
    
    @base_down = SDL::Surface.new(SDL::SRCALPHA, @width+3, @height+3, 32, 0x000000ff, 0x0000ff00, 0x00ff0000, 0xff000000)    
    @base_down.fill_rect(1, 1, @width+2, @height+2, [0, 0, 0])
    @base_down.put(@image, 2, 2)
    @base_down.draw_rect(2, 2, @width, @height, [0, 0, 255])
    @base_down.draw_rect(3, 3, @width-2, @height-2, [255, 255, 255])
    @font.draw_solid_utf8(@base_down, @string, (@width/2)-(@str_size/2)*(@font_size/2)+2, (@height/2)-(@font_size/2)+2, 0, 0, 0)        #TTF�`��
  end

  def draw_unpush(screen)
    screen.put(@base_up, @x, @y)
  end
  
  def draw_push(screen)
    screen.put(@base_down, @x, @y)  
  end
  
  def inside?(mouse_x, mouse_y)                         
    (@x .. @x+@width).include?(mouse_x) and
    (@y .. @y+@height).include?(mouse_y)
  end
  
  #�{�^�����ō��N���b�N�{�^���������ꂽ�瓮��
  def check
    mouse_x, mouse_y, left_button, * = SDL::Mouse.state
    if left_click_event?(left_button)
      if inside?(mouse_x, mouse_y)
        @pushed = true
      else
        @pushed = false
      end
    end
  end
  
  def left_click_event?(left_button)
    if left_button and @pressed == false
      @pressed = true
      return true
    elsif left_button == false and @pressed
      @pressed = false
      return false
    else
      return false
    end
  end
  
  def pushed?
    self.check
    #@pushed
  end
  
  def render(screen)
    draw_unpush(screen)
  end
  
  #���o�[�W�����̌݊��̂��߁D���݂�render�œ���
  def draw(screen)
    draw_unpush(screen)
  end

        
#���ǑO�͈ȉ�  
=begin  
  def check
    mouse_x, mouse_y, leftclick, * = SDL::Mouse.state
    if leftclick
      if inside?(mouse_x, mouse_y) == false
        @prev_clicked = true
        @press = false
      elsif @prev_clicked == false
        @press = true
      end
    else
      if inside?(mouse_x, mouse_y) and @press
        @pushed = true
      else
        @pushed = false  
      end
      @press = false
      @prev_clicked = false
    end
  end
    
  def pushed?
    self.check
    @pushed
  end
  
  def press?
    self.check
    @press 
  end
     
  def render(screen)
    if self.press?
      draw_push(screen)
    else
      draw_unpush(screen)
    end
  end
=end
  
end

