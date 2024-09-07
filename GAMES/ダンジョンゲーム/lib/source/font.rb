require 'dxruby'

class Fonts
  def initialize(x=0, y=0, string="", font_size=28, st_color=[255,255,255])
    @font_style = Font.new(font_size,"‚l‚r ‚oƒSƒVƒbƒN")
    @x, @y      = x, y
    @string     = string
    @st_color   = st_color
  end
  attr_accessor :x, :y , :string, :font_size, :st_color
  
  #•`‰æˆÊ’u‚ÌÝ’è
  def set_pos(x, y)
    @x, @y = x, y
  end
  
  #•¶Žš‚Ì‰¡•‚ðŽæ“¾
  def get_width
    @font_style.get_width(@string)
  end
  
  #F‚ÌÝ’è(‚±‚Á‚¿‚Ì•û‚ªRuby‚Á‚Û‚¢)  
  def color=(color)
    @red, @green, @blue = color
  end
  
  #ƒ‰ƒxƒ‹‚ÌÝ’è
  def name(string)
    @string = string
  end
  
  
  
  def render
    Window.drawFont(@x, @y, @string, @font_style, :color => @st_color)
  end
end
