
=begin
#�E�g����#############################################################
 @check = Checkbox.new(100,200,"�`�F�b�N")  
 @check.draw            # �`�F�b�N�{�b�N�X�̕`��
 @check.clicked?        # �N���b�N���� --->  MouseDown �� MouseUp �̒��ɒu��
 @check.checked?        # �`�F�b�N����Ă���Ȃ� true ��Ԃ�
#######################################################################
=end

class Checkbox
  def initialize(x,y,st = " ")
    @x = x
    @y = y
    @st = st
    @color = [0,0,0]
    begin
      @box = Image.load("image/checkbox.png")
      @check = Image.load("image/check.png")
    rescue
      puts "'checkbox.png'��'check.png' �̉摜������܂���B"
      exit
    end
    @fontsize = 30
    @font = Font.new(@fontsize)
    make_checkbox
    @flag_clicked = 0
  end
  
  def make_checkbox
#=begin
    w = (@st.size+2) * (@fontsize.to_f/2) + 25
    h = 40 #@fontsize +10
    @checkbox = Image.new(w,h,[0,255,255,255])
    @checkbox.draw(5,5,@box)
    @checkbox.drawFont(50,5,@st,@font,@color)
#=end
  end
  
  def chang_color(color)
    @color = color
    make_checkbox
  end
  
  def clicked?
    x, y = Input.mousePosX, Input.mousePosY
    if (@x+5..@x+35).include?(x)
     if (@y+5..@y+35).include?(y)
      if Input.mousePush?(M_LBUTTON)
        if @flag_clicked == 0
          @flag_clicked = 1
        #else
        #  @flag_clicked = 0
        end
        draw_checkmark
      end
     end
    end
  end
  
  def reset
    @flag_clicked = 0
    draw_checkmark
  end
  
  def set
    @flag_clicked = 1
    draw_checkmark
  end
  
  def draw_checkmark
    if @flag_clicked == 1
      @checkbox.draw(5,5,@check)
    else
      @checkbox.draw(5,5,@box)
    end
  end
  
  def draw
    Window.draw(@x,@y,@checkbox)
  end
  
  def checked?
    if @flag_clicked == 1
      return true
    else
      return false
    end
  end
end
