#!ruby -Ks
require 'vr/vruby'
require 'vr/vrcontrol' #標準コントロール(ボタンやテキストなど)のライブラリ
require "vr/vrdialog"
require 'lib/file_op'
include File_operation
$title="設定画面"
$edit_folder="question"##編集するテキストが入っているフォルダ名までのパス

class MyForm < VRForm
  def construct    #ウインドウが作成された時に呼び出されるメソッド（初期化その1）
    self.move 100,100,800,600 #座標x,座標y,幅,高さ

    addControl(VRStatic,'title',"Maglab tools 問題設定画面",200,10,300,40)
    addControl(VRStatic,'file_select',"1.変更したいファイルを選択し「表示」ボタンを押してください.",10,50,500,40)
    addControl(VRCombobox,'combo',"",20,80,200,180)##コンボボックス(ファイル選択用)
    addControl(VRButton,'btn1',"表示",220,78,100,30,0x0300)
    @f=0##表示用フラグ
  end
  
  def load
    data=file_load("#{$edit_folder}/#{@name}",1)
    @data=data[0]
    if @data!=nil
      @data+="\r\n"
      for i in 1..data.size-1
        @data+=data[i]
        @data+="\r\n"
      end
    @text1.caption=@data
    end
  end
  
  def load_fname##editディレクトリ内の全てのファイル名を取得→コンボボックスに表示
    files = Dir::entries("#{$edit_folder}")
    n = 0
    while n <= files.size##編集するテキストファイル以外のものを削除
      if files[n] == "Tumbs.db"
        files.delete_at(n)
      elsif files[n] == "." or files[n] == ".."##編集するテキストファイル以外のものを削除(追加修正)
        files.delete_at(n)
      else
        n += 1
      end
    end
    for i in 0..files.size##編集するテキストファイル以外のものを削除(予備)
      if File::extname("#{files[i]}")!=".txt"
        files.delete_at(i)
      end
    end
    @combo.setListStrings files
    @combo.select(0)
  end
  
  def self_created #constructの後に呼び出されるメソッド（初期化その2）
    self.caption = $title  #表題
    load_fname
  end
  
  def btn1_clicked##ファイル内のデータを表示するボタン
    @name = @combo.getTextOf(@combo.selectedString)
    if @f==0
      addControl(VRStatic,'file_edit',"2.問題を編集し「変更」ボタンを押してください.",10,120,500,40)
      addControl(VRText,'text1',"#{@data}",20,150,350,200,WStyle::WS_VSCROLL|WStyle::WS_HSCROLL)
      addControl(VRStatic,'label1',"",450,150,270,330,0)
      addControl(VRButton,'btn2',"変更",100,350,100,30,0x0300)
      addControl(VRStatic,'label2',"保存された内容",500,120,270,330,0)
      @f=1
    elsif @f==1
    end
    load
  end
  
  def btn2_clicked##設定変更ボタン
    @label1.caption = @text1.text
    file_make("#{$edit_folder}/#{@name}",@text1.text)
  end
end

frm=VRLocalScreen.newform(nil, nil, MyForm)
frm.create.show
VRLocalScreen.messageloop
