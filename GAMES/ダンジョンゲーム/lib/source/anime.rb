# -*- encoding: utf-8 -*-
require "dxruby"

class Wind_beam <Sprite

  #画像ファイル
  Windbeam = "./image/Main_Scene2/pipo-btleffect148c.png"

  # 複数のアニメ画像を並べたスプライト・シートの読み込みとフレームへの分割を同時に行う。
  # @@ はクラス内の最も外側の変数に付けます。スコープ（有効範囲）はクラス内全体で大文字パラメータと同義です。
  @@windBeam = Image.load_tiles(Windbeam, 1, 10, true) # 引数は縦横の分割数です。

  # 初期化メソッド（new でこのクラスのオブジェクトをこしらえた直後に一度だけ実行されるメソッドです）。
  def initialize(x, y) # x, y は new でオブジェクト作成時の引数（オブジェクトの出現位置です）。

    # self はこのクラス自身を意味します。継承したメンバ変数、またはメソッドを上書き指定します。
    self.image = @@windBeam[0]
    self.x = x
    self.y = y
    self.target = Window # 今回のレンダー・ターゲット（描画対象）は最上部レイヤのWindow自身。

    # 継承したメンバに含まれないメンバ変数を @ をつけて自分で作ります。スコープはクラス全体です。
    @windAniCount = 0  # アニメーション用カウンタ
    @frame = 0
    @cahrY0 = y
  end

  def update
    self.wait
  end


  def draw
    Window.draw_ex(self.x,self.y,@@windBeam[@windAniCount/20],:angle => 0, :alpha => 255, :scalex => 2.0, :scaley => 1.2) #設定
  end

  def wait
    @windAniCount += 4
    if @windAniCount >= 200
      @windAniCount = 0
    end
  end


  # DXRuby の Image には幅、高さメソッドが備わっているが、Sprite には存在しないらしいです。
  def width
    self.image.width
  end

  def height
    self.image.height
  end

  def set_pos(x, y)
    @x, @y = x, y
  end

end

# テスト・コード
# クラス・ファイルの単体テスト
# 直接このファイルを走らせた場合に実行されるコード
if __FILE__ == $0

  Window.bgcolor = C_WHITE #ここで実行している
  encount = Wind_beam.new(0, 0)
  Window.loop do
    Sprite.update(encount)
    Sprite.draw(encount)
  end
end
