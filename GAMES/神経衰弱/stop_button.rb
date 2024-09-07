require "sdl"
require "nkf"

class StopButton
 def initialize(screen)
   #�X�N���[���̑傫������A�{�^���̕\���ʒu������
   @screen = screen
   @x = screen.w - 120
   @y = 0
   @x_help = 400
   @y_help = 500
   @button_color = [220,220,220]
   @r,@g,@b   = 0,0,0 #�t�H���g�̐F
   self.mk_image(120,60)
   @font = SDL::TTF.open('C:\WINDOWS\Fonts\MSGOTHIC.TTC', 12)
   @font2 = SDL::TTF.open('C:\WINDOWS\Fonts\MSGOTHIC.TTC', 35)
   
   @time_help = 0 #[�w���v]�̉�ʂ�\�����Ă������Ԃ̍��v
 end

 def mk_image(w,h)
   # 60x60 �̉摜���쐬
   @image = SDL::Surface.new(SDL::SRCALPHA,w,h,32,0x000000ff, 0x0000ff00, 0x00ff0000, 0xff000000)
   @image.fill_rect(0,0,w,h,[150,150,150])
   @image.fill_rect(3,3,w-6,h-6,@button_color)
   left = w/2 +10
   @image.draw_line(left-10,0,left-10,h,[150,150,150])
 end
 
 #�{�^���̕\���ʒu��ύX�������ꍇ�Ɏg�p
 def set_pos(x,y)
   @x,@y = x,y
 end
 
 #�{�^���̔w�i�F�̕ύX
 def set_button_color(r, g, b)
   @button_color = [r,g,b]
   self.mk_image(@image.w,@image.h) #�{�^���̏�������
 end
  
 #�{�^���̃t�H���g�F�̕ύX
 def set_font_color(r, g, b)
   @r,@g,@b = r,g,b
 end
 
 def pushed?
   x, y, lbutton, * = SDL::Mouse.state
   if lbutton #�}�E�X�̍��{�^���������ꂽ��
    if (@y..@y+@image.h).include?(y)
     if (@x..@x+@image.w/2).include?(x)
       self.setsumei
     elsif (@x+@image.w/2..@x+@image.w).include?(x)
       exit
     end
    end
   end
 end
 
 def setsumei
   time_start = SDL.getTicks/1000.0
   @screen.fill_rect(0,0,@screen.w,@screen.h,[220,220,220])
   @screen.fill_rect(@x_help,@y_help,224,60,[150,150,150])
   @screen.fill_rect(@x_help+3,@y_help+3,218,54,@button_color)
   
   #�\�����������ҏW
   @font2.draw_solid_utf8(@screen, NKF.nkf('-w',"�w���v"),200,300,0,0,0)
   
   @font2.draw_solid_utf8(@screen, NKF.nkf('-w',"���ǂ�"),@x_help+50,@y_help+9,0,0,0)
   @screen.update_rect(0,0,0,0)

   if SDL::Mouse.show? #�}�E�X�̃J�[�\���͕\������Ă��邩�H
     flag = 0
   else
     flag = 1
     SDL::Mouse.show
   end
   
   loop = "do"
   while loop == "do"
     
    while event=SDL::Event2.poll
     case event
     when SDL::Event2::Quit
        exit
     when SDL::Event2::KeyDown
        if event.sym == SDL::Key::ESCAPE
          exit
        end
     when SDL::Event2::MouseButtonDown
        ## �߂�{�^���������ꂽ����
        if (@x_help..@x_help+224).include?(event.x)
         if (@y_help..@y_help+60).include?(event.y)
           SDL::Mouse.hide if flag == 1 #�}�E�X�̃J�[�\���̕\����߂�
           loop = "end"
           
           time_end = SDL.getTicks/1000.0
           time_show = time_end - time_start
           @time_help += time_show
           
           self.return_screen
         end
        end
     end
    end
    
   end
 end
 
 def return_screen
   @screen.fill_rect(0,0,1024,768,[220,220,220])
 end
 
 def draw
   @screen.put(@image,@x,@y)
   @font.draw_solid_utf8(@screen, NKF.nkf('-w',"���߂�"),@x+6,@y+22,@r,@g,@b)
   @font.draw_solid_utf8(@screen, NKF.nkf('-w',"���イ��"),@x+@image.w/2+5,@y+22,@r,@g,@b)
   @screen.update_rect(@x,@y,@image.w,@image.h)
 end
 
 def time?
   return @time_help
 end
 
 def timer_reset
   @time_help = 0
 end
end

