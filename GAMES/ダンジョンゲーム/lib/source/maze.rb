# scene���W���[��������ɉ���
# ��{�f�[�^�̒ǋL
require 'dxruby'

module Scene
  class Exit
  end

  class Base
    attr_accessor :next_scene
    attr_reader :frame_counter

    def initialize
      @next_scene = nil
      @frame_counter = 0
      init
    end

    def __update
      @frame_counter += 1
      update
    end
    private :__update

    def init
    end

    def quit
    end

    def update
    end

    def render
    end
  end

  def self.main_loop(scene_class, fps = 60, step = 1)
    scene = scene_class.new
    default_step = step

    Window.loop do
      exit if Input.keyPush?(K_ESCAPE)
      if Input.keyPush?(K_PGDN)
        step += 1
        Window.fps = fps * default_step / step
      end

      if Input.keyPush?(K_PGUP) and step > default_step
        step -= 1
        Window.fps = fps * default_step / step
      end

      step.times do
        break if scene.next_scene
        scene.__send__ :__update
      end

      scene.render

      if scene.next_scene
        scene.quit
        break if Exit == scene.next_scene
        scene = scene.next_scene.new
      end
    end
  end
end
#####################################################################
class Init_Scene  < Scene::Base
  #�^�C�g����ʂ̏��X�̒�`�@���������火
  def maze_init
    
    ###���i�쐬###
    @width = 20#���H��
    @height = 20#���H����
    #$maze = Array.new(@width+1){Array.new(@height+1)}
    $maze = Array.new(50){Array.new(50)}
    for i in 0..@height
      for j in 0..@width
        if i==0 || i==@height || j==0 || j==@width 
          $maze[i][j] = 1#��
        else
          $maze[i][j] = 0#��
        end
      end
    end
    
    
    
=begin
    $monster[i].y = 1280
    $monster[i].x = 1280
    @img[i][j] = Images.new(j*30+$masu_posi[0], i*30+$masu_posi[1], 30, 30, "", 24, Gray, Black)
=end
    ##
#=begin
    #�K���ɕǂ������
    $maze[40][36] = 1
    $maze[40][37] = 1
    $maze[40][38] = 1
    $maze[40][39] = 1
    ##
    $maze[39][38] = 1
    $maze[39][39] = 1
    $maze[39][40] = 1
#=end
    $maze[40][40] = 1
    ###���H�쐬###
    i = 2
    while i < @height
      j = 2
      while j < @width
        $maze[i][j] = 1
        if i == 2 
          wall_course = rand(4)
        else
          wall_course = rand(3)
        end
        case wall_course
          when 0#���ɓ|��
            $maze[i+1][j] = 1
            j += 2
          when 1#���ɓ|��
            if $maze[i][j-1] == 1#�d�Ȃ����ꍇ������x
              j += 0
            else
              $maze[i][j-1] = 1
              j += 2
            end
          when 2#�E�ɓ|��
            $maze[i][j+1] = 1
            j += 2
          when 3#��ɓ|��
            $maze[i-1][j] = 1
            j += 2
        end
      end
      i += 2
    end
    ###���H�\��###
    @img = Array.new(@width+1){Array.new(@height+1)}
    for i in 0..@height
      for j in 0..@width
        if $maze[i][j] == 0 #��
          @img[i][j] = Images.new(j*30+$masu_posi[0], i*30+$masu_posi[1], 30, 30, "", 24, Gray, Black)
          #@img[i][j].image("./image/mapchip0.png")
        else #��
          @img[i][j] = Images.new(j*30+$masu_posi[0], i*30+$masu_posi[1], 30, 30, "", 24, Dgray, Black)
          #@img[i][j].image("./image/mapchip0.png")
        end
      end
    end
    
=begin
    for i in  0..@height
      #�}�X�̕�����������
      @img[0][i].image("./image/mapchip1.png")
      @img[@height][i].image("./image/mapchip1.png")
      @img[i][0].image("./image/mapchip1.png")
      @img[i][@height].image("./image/mapchip1.png")
    end
=end

#�g�̂S�ӂɊD�F�ɂ���
    for i in 1..@height-1
      @img[i][1].color(Gray)
      $maze[i][1] = 0#��
      @img[i][@height-1].color(Gray)
      $maze[i][@height-1] = 0#��
      @img[1][i].color(Gray)
      $maze[1][i] = 0#��
      @img[@height-1][i].color(Gray)
      $maze[@height-1][i] = 0#��
    end
    
############�ǉ�
    for i in 0..@height
      for j in 0..@width
        if $maze[i][j] == 0
          if $maze[i-1][j] == 1 && $maze[i-1][j-1] == 1 && $maze[i-1][j+1] == 1 && $maze[i][j+1] == 1 && $maze[i+1][j+1] == 1 && $maze[i+1][j] == 1 && $maze[i+1][j-1] == 1
            $maze[i-1][j] = 0 #���������
            @img[i-1][j].color(Gray) #���������
          end
        end
      end
    end
    
    for i in 0..@height
      for j in 0..@width
        if $maze[i][j] == 0
          if $maze[i-1][j] == 1 && $maze[i-1][j-1] == 1 && $maze[i-1][j+1] == 1 && $maze[i][j-1] == 1 && $maze[i+1][j+1] == 1 && $maze[i+1][j] == 1 && $maze[i+1][j-1] == 1
            $maze[i+1][j] = 0 #����������
            @img[i+1][j].color(Gray) #����������
          end
        end
      end
    end
    
    for i in 0..@height
      for j in 0..@width
        if $maze[i][j] == 0
          if $maze[i][j-1] == 1 && $maze[i-1][j-1] == 1 && $maze[i-1][j+1] == 1 && $maze[i][j+1] == 1 && $maze[i+1][j+1] == 1 && $maze[i+1][j] == 1 && $maze[i+1][j-1] == 1
            $maze[i][j+1] = 0 #�E��������
            @img[i][j+1].color(Gray) #�E��������
          end
        end
      end
    end
      
    for i in 0..@height
      for j in 0..@width
        if $maze[i][j] == 0
          if $maze[i-1][j] == 1 && $maze[i-1][j-1] == 1 && $maze[i-1][j+1] == 1 && $maze[i][j+1] == 1 && $maze[i][j-1] == 1 && $maze[i+1][j-1] == 1 && $maze[i+1][j+1] == 1
            $maze[i][j-1] = 0 #����������
            @img[i][j-1].color(Gray) #����������
          end
        end
      end
    end
############�ǉ�
  end #init
  
  def maze_update
  
  end #update
  
  def maze_render
  
  end #render
end #scene
##################################################################
