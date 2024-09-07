require 'dxruby'

class Fonts
  attr_accessor :string, :x, :y , :size, :color, :font_sty
  def initialize(string, x=0 , y = 0, size = 72,color=[0,0,0],font_sty = "‚l‚r ‚oƒSƒVƒbƒN")
    @font_style = Font.new(size,font_sty)
    @color = color
    @x , @y = x, y
    @string = string
  end
  
  #•`‰æˆÊ’u‚ÌÝ’è
  def set_pos(x, y)
    @x, @y = x, y
  end
  
  #F‚ÌÝ’è(‚±‚Á‚¿‚Ì•û‚ªRuby‚Á‚Û‚¢)  
  def color=(color)
    @red, @green, @blue = color
  end
  
  def render
    Window.drawFont(@x , @y, @string, @font_style, :color => @color)
  end
end
