#!ruby -Ks
# ���� �g���� ����
#  �E���̃t�@�C����require���āA���̖��߂ŋN��������B
#      VRLocalScreen.modalform(nil,nil,MyForm)
#  �E$name �Ƃ����ϐ��ɓ��͂��ꂽ�����񂪓����Ă�̂ŁA���O�̃t�@�C�����ɒǉ�����B

require 'vr/vruby'
require 'vr/vrcontrol' #�W���R���g���[��(�{�^����e�L�X�g�Ȃ�)�̃��C�u����
require 'vr/vrdialog'
class MyForm < VRModalDialog
  def construct    #�E�C���h�E���쐬���ꂽ���ɌĂяo����郁�\�b�h�i����������1�j
    self.move 100,50,400,200 #���Wx,���Wy,��,����
    self.caption = "input name"  #�\��  
    @font = @screen.factory.newfont( "�l�r �S�V�b�N",30 )
    self.class::const_set("DEFAULT_FONT", @font)
    style = WStyle::WS_TABSTOP
    addControl(VREdit,'edit1',"���O or ID",20,30,350,40,style | WStyle::WS_BORDER)
    addControl(VRButton,'button1',"����",200,100,150,50)
    setButtonAs(@button1,IDOK)
    setButtonAs(@button1, IDCANCEL) # [Esc]�L�[�ŏI���ł���悤��
  end
  
  def button1_clicked
    $name = @edit1.text
    $name = "" if $name == "��������I"
    close(true)
  end
end

if __FILE__ == $0
  # program�̋N����
  VRLocalScreen.modalform(nil,nil,MyForm)
  p $name
end

