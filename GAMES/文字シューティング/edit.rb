#!ruby -Ks
require 'vr/vruby'
require 'vr/vrcontrol' #�W���R���g���[��(�{�^����e�L�X�g�Ȃ�)�̃��C�u����
require "vr/vrdialog"
require 'lib/file_op'
include File_operation
$title="�ݒ���"
$edit_folder="question"##�ҏW����e�L�X�g�������Ă���t�H���_���܂ł̃p�X

class MyForm < VRForm
  def construct    #�E�C���h�E���쐬���ꂽ���ɌĂяo����郁�\�b�h�i����������1�j
    self.move 100,100,800,600 #���Wx,���Wy,��,����

    addControl(VRStatic,'title',"Maglab tools ���ݒ���",200,10,300,40)
    addControl(VRStatic,'file_select',"1.�ύX�������t�@�C����I�����u�\���v�{�^���������Ă�������.",10,50,500,40)
    addControl(VRCombobox,'combo',"",20,80,200,180)##�R���{�{�b�N�X(�t�@�C���I��p)
    addControl(VRButton,'btn1',"�\��",220,78,100,30,0x0300)
    @f=0##�\���p�t���O
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
  
  def load_fname##edit�f�B���N�g�����̑S�Ẵt�@�C�������擾���R���{�{�b�N�X�ɕ\��
    files = Dir::entries("#{$edit_folder}")
    n = 0
    while n <= files.size##�ҏW����e�L�X�g�t�@�C���ȊO�̂��̂��폜
      if files[n] == "Tumbs.db"
        files.delete_at(n)
      elsif files[n] == "." or files[n] == ".."##�ҏW����e�L�X�g�t�@�C���ȊO�̂��̂��폜(�ǉ��C��)
        files.delete_at(n)
      else
        n += 1
      end
    end
    for i in 0..files.size##�ҏW����e�L�X�g�t�@�C���ȊO�̂��̂��폜(�\��)
      if File::extname("#{files[i]}")!=".txt"
        files.delete_at(i)
      end
    end
    @combo.setListStrings files
    @combo.select(0)
  end
  
  def self_created #construct�̌�ɌĂяo����郁�\�b�h�i����������2�j
    self.caption = $title  #�\��
    load_fname
  end
  
  def btn1_clicked##�t�@�C�����̃f�[�^��\������{�^��
    @name = @combo.getTextOf(@combo.selectedString)
    if @f==0
      addControl(VRStatic,'file_edit',"2.����ҏW���u�ύX�v�{�^���������Ă�������.",10,120,500,40)
      addControl(VRText,'text1',"#{@data}",20,150,350,200,WStyle::WS_VSCROLL|WStyle::WS_HSCROLL)
      addControl(VRStatic,'label1',"",450,150,270,330,0)
      addControl(VRButton,'btn2',"�ύX",100,350,100,30,0x0300)
      addControl(VRStatic,'label2',"�ۑ����ꂽ���e",500,120,270,330,0)
      @f=1
    elsif @f==1
    end
    load
  end
  
  def btn2_clicked##�ݒ�ύX�{�^��
    @label1.caption = @text1.text
    file_make("#{$edit_folder}/#{@name}",@text1.text)
  end
end

frm=VRLocalScreen.newform(nil, nil, MyForm)
frm.create.show
VRLocalScreen.messageloop
