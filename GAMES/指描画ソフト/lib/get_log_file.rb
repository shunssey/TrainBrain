#!ruby -Ks
require 'vr/vruby'
require 'vr/vrcontrol'
require "vr/vrdialog"


class MyForm < VRModalDialog
  def construct
    self.move 100,0,480,200
    self.caption = "Load LogFile"
    addControl(VRStatic,"lbl","�Đ��������t�@�C����I��ł�������",20,5,440,50)
    addControl(VRCombobox,"combo","",20,50,400,300)
    addControl(VRButton,"btn","�J��",300,100,150,50)
    addControl(VRButton,"exit","�I��",0,350,150,50)
    setButtonAs(@exit,IDCANCEL) # ESC �������ꂽ��Aexit�{�^���������ꂽ���Ƃɂ���B
    setButtonAs(@btn,IDOK)
  end
  
  def self_created
    @font = @screen.factory.newfont("MS ����",25)
    @lbl.setFont @font
    @combo.setFont @font
    @btn.setFont @font
    
    #@combo.setListStrings ["1_�v.csv","2_���H.csv","3_��.csv","4_�i.csv","5_��.csv","6_��.csv","7_��.csv","8_��.csv"]
    
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
