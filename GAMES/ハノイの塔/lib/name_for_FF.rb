#!ruby -Ks
# ◆◆ 使い方 ◆◆
#  ・このファイルをrequireして、次の命令で起動させる。
#      VRLocalScreen.modalform(nil,nil,MyForm)
#  ・$name という変数に入力された文字列が入ってるので、ログのファイル名に追加する。

require 'vr/vruby'
require 'vr/vrcontrol' #標準コントロール(ボタンやテキストなど)のライブラリ
require 'vr/vrdialog'
class MyForm < VRModalDialog
  def construct    #ウインドウが作成された時に呼び出されるメソッド（初期化その1）
    self.move 100,50,400,200 #座標x,座標y,幅,高さ
    self.caption = "input name"  #表題  
    @font = @screen.factory.newfont( "ＭＳ ゴシック",30 )
    self.class::const_set("DEFAULT_FONT", @font)
    style = WStyle::WS_TABSTOP
    addControl(VREdit,'edit1',"名前 or ID",20,30,350,40,style | WStyle::WS_BORDER)
    addControl(VRButton,'button1',"入力",200,100,150,50)
    setButtonAs(@button1,IDOK)
    setButtonAs(@button1, IDCANCEL) # [Esc]キーで終了できるように
  end
  
  def button1_clicked
    $name = @edit1.text
    $name = "" if $name == "ここだよ！"
    close(true)
  end
end

if __FILE__ == $0
  # programの起動↓
  VRLocalScreen.modalform(nil,nil,MyForm)
  p $name
end

