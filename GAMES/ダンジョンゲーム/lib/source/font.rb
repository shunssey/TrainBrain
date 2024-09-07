require 'dxruby'

class Fonts
  def initialize(x=0, y=0, string="", font_size=28, st_color=[255,255,255])
    @font_style = Font.new(font_size,"�l�r �o�S�V�b�N")
    @x, @y      = x, y
    @string     = string
    @st_color   = st_color
  end
  attr_accessor :x, :y , :string, :font_size, :st_color
  
  #�`��ʒu�̐ݒ�
  def set_pos(x, y)
    @x, @y = x, y
  end
  
  #�����̉������擾
  def get_width
    @font_style.get_width(@string)
  end
  
  #�F�̐ݒ�(�������̕���Ruby���ۂ�)  
  def color=(color)
    @red, @green, @blue = color
  end
  
  #���x���̐ݒ�
  def name(string)
    @string = string
  end
  
  
  
  def render
    Window.drawFont(@x, @y, @string, @font_style, :color => @st_color)
  end
end
