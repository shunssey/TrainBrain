require 'dxruby'

class Fonts
  attr_accessor :string, :x, :y , :size, :color
  def initialize(string, x=0 , y = 0, size = 72,color=[0,0,0])
    @font_style = Font.new(size,"HG正楷書体-PRO")
    @color = color
    @x , @y = x, y
    @string = string
  end
  
  def string=(string)
    @string = string
  end
  
  #描画位置の設定
  def set_pos(x, y)
    @x, @y = x, y
  end
  
  #色の設定(こっちの方がRubyっぽい)  
  def color=(color)
    @red, @green, @blue = color
  end
  
  def render
    Window.drawFont(@x , @y, @string, @font_style, :color => @color)
  end
end
