#!ruby -Ks
require 'vr/vruby'
require 'vr/vrcontrol'
require "vr/vrdialog"


class MyForm < VRModalDialog
  def construct
    self.move 100,0,480,200
    self.caption = "Load LogFile"
    addControl(VRStatic,"lbl","再生したいファイルを選んでください",20,5,440,50)
    addControl(VRCombobox,"combo","",20,50,400,300)
    addControl(VRButton,"btn","開く",300,100,150,50)
    addControl(VRButton,"exit","終了",0,350,150,50)
    setButtonAs(@exit,IDCANCEL) # ESC が押されたら、exitボタンが押されたことにする。
    setButtonAs(@btn,IDOK)
  end
  
  def self_created
    @font = @screen.factory.newfont("MS 明朝",25)
    @lbl.setFont @font
    @combo.setFont @font
    @btn.setFont @font
    
    #@combo.setListStrings ["1_思.csv","2_朝食.csv","3_張.csv","4_景.csv","5_精.csv","6_翌.csv","7_銅.csv","8_泉.csv"]
    
#=begin
    if __FILE__ == $0
      @files = Dir::entries("../log")
      #p "../log"
    else
      @files = Dir::entries("log")
      #p "log"
    end
    
    n = 0
    delete = Array.new
    while n <= @files.size
      if @files[n] == "Tumbs.db"
        @files.delete_at(n)
      elsif @files[n] == "." or @files[n] == ".."
        @files.delete_at(n)
      else
        #name = @files[n]
        #name.gsub!(".csv","") if name.include?(".csv")
        #@files[n] = name
        #@files[n].gsub!(".csv","") if @files[n].include?(".csv")
        n += 1
      end
    end
    
    files_c = []
    for i in 0 .. @files.size-1
      st = @files[i]
      ary = st.delete(".csv").split("_")
      date, time = ary[4], ary[5]
      files_c[i] = "#{ary[1]} -#{date[0..1]}/#{date[2..3]} #{time[0..1]}:#{time[2..3]}- (#{ary[3]})"
    end
    
    #@combo.setListStrings @files
    @combo.setListStrings files_c
#=end
    
    @combo.select(0)
  end
  
  def btn_clicked
     #p @combo.getTextOf(@combo.selectedString)
     name = @files[@combo.selectedString]
     pass = "log/" + name # + ".csv"
     $filename = pass
     close(1)
  end
  
  def exit_clicked
    exit
  end
  
end


if __FILE__ == $0
  frm=VRLocalScreen.modalform(nil,nil,MyForm)
  VRLocalScreen.messageloop
  
  p $filename
end
