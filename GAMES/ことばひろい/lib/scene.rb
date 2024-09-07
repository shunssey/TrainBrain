# MyGame��scene.rb��MyGame�Ɉˑ����Ȃ��悤�ɐ؂藣�����ėpscene���W���[���B
# �ł�DXRuby��p�ł��B
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

  def self.main_loop(scene_class)
    scene = scene_class.new

    Window.loop do
    
      if Input.keyPush?(K_ESCAPE) then  # Esc�L�[�ŏI��
        break
      end

      break if scene.next_scene
      scene.__send__ :__update

      scene.render

      if scene.next_scene
        scene.quit
        break if Exit == scene.next_scene
        scene = scene.next_scene.new
      end
    end
  end
end
######################################################
