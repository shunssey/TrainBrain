require 'dxruby'

class Fonts
  def initialize(x=0, y=0, string="", font_size=28, st_color=[255,255,255])
    @font_style = Font.new(font_size,"ＭＳ Ｐゴシック")
    @x, @y      = x, y
    @string     = string
    @st_color   = st_color
  end
  attr_accessor :x, :y , :string, :font_size, :st_color
  
  #描画位置の設定
  def set_pos(x, y)
    @x, @y = x, y
  end
  
  #文字の横幅を取得
  def get_width
    @font_style.get_width(@string)
  end
  
  #色の設定(こっちの方がRubyっぽい)  
  def color=(color)
    @red, @green, @blue = color
  end
  
  #ラベルの設定
  def name(string)
    @string = string
  end
  
  
  
  def render
    Window.drawFont(@x, @y, @string, @font_style, :color => @st_color)
  end
end
