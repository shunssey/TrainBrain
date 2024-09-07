require 'dxruby'

class Fonts
  def initialize(string, x=0 , y = 0, size = 72,color=[0,0,0])
    @font_style = Font.new(size,"HG³ž²‘‘Ì-PRO")
    @color = color
    @x , @y = x, y
    @string = string
  end
  attr_accessor :string, :x, :y , :size, :color
  
  #•`‰æˆÊ’u‚ÌÝ’è
  def set_pos(x, y)
    @x, @y = x, y
  end
  
  def color(color)
    @color = color
  end
  
  def render
    Window.drawFont(@x , @y, @string, @font_style, :color => @color)
  end
end
