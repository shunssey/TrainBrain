# -*- encoding: utf-8 -*-
require "dxruby"

=begin
#�t�B�[�����O�A�j��
class Gmae_clear <Sprite

  #�摜�t�@�C��
  Yellowflash2 = "./image/pipo-btleffect150c.png"

  # �����̃A�j���摜����ׂ��X�v���C�g�E�V�[�g�̓ǂݍ��݂ƃt���[���ւ̕����𓯎��ɍs���B
  # @@ �̓N���X���̍ł��O���̕ϐ��ɕt���܂��B�X�R�[�v�i�L���͈́j�̓N���X���S�̂ő啶���p�����[�^�Ɠ��`�ł��B
  @@yellowFlash2 = Image.load_tiles(Yellowflash2, 1, 5, true) # �����͏c���̕������ł��B

  # ���������\�b�h�inew �ł��̃N���X�̃I�u�W�F�N�g�������炦������Ɉ�x�������s����郁�\�b�h�ł��j�B
  def initialize(x, y) # x, y �� new �ŃI�u�W�F�N�g�쐬���̈����i�I�u�W�F�N�g�̏o���ʒu�ł��j�B

    # self �͂��̃N���X���g���Ӗ����܂��B�p�����������o�ϐ��A�܂��̓��\�b�h���㏑���w�肵�܂��B
    self.image = @@yellowFlash2[0]
    self.x = x
    self.y = y
    self.target = Window # ����̃����_�[�E�^�[�Q�b�g�i�`��Ώہj�͍ŏ㕔���C����Window���g�B

    # �p�����������o�Ɋ܂܂�Ȃ������o�ϐ��� @ �����Ď����ō��܂��B�X�R�[�v�̓N���X�S�̂ł��B
    @Yellowflash2AniCount = 0  # �A�j���[�V�����p�J�E���^
    @frame = 0
    @cahrY0 = y
  end

  def update
    self.wait
  end


  def draw
    Window.draw_ex(self.x,self.y,@@yellowFlash2[@Yellowflash2AniCount/30],:angle => 0, :alpha => 255, :scalex => 1.0, :scaley => 1.0) #�ݒ�
  end

  def wait
    @Yellowflash2AniCount += 4
    if @Yellowflash2AniCount >= 120 #@Yellowflash2AniCount/30�̂R�O��@Yellowflash2AniCount+=4�̂S���|��������
      @Yellowflash2AniCount = 0
    end
  end


  # DXRuby �� Image �ɂ͕��A�������\�b�h��������Ă��邪�ASprite �ɂ͑��݂��Ȃ��炵���ł��B
  def width
    self.image.width
  end

  def height
    self.image.height
  end

  def set_pos(x, y)
    @x, @y = x, y
  end

end
=end

#�_���[�W�A�j��
=begin
class Yellow_flash2 <Sprite

  #�摜�t�@�C��
  Yellowflash2 = "./image/pipo-btleffect150c.png"

  # �����̃A�j���摜����ׂ��X�v���C�g�E�V�[�g�̓ǂݍ��݂ƃt���[���ւ̕����𓯎��ɍs���B
  # @@ �̓N���X���̍ł��O���̕ϐ��ɕt���܂��B�X�R�[�v�i�L���͈́j�̓N���X���S�̂ő啶���p�����[�^�Ɠ��`�ł��B
  @@yellowFlash2 = Image.load_tiles(Yellowflash2, 1, 5, true) # �����͏c���̕������ł��B

  # ���������\�b�h�inew �ł��̃N���X�̃I�u�W�F�N�g�������炦������Ɉ�x�������s����郁�\�b�h�ł��j�B
  def initialize(x, y) # x, y �� new �ŃI�u�W�F�N�g�쐬���̈����i�I�u�W�F�N�g�̏o���ʒu�ł��j�B

    # self �͂��̃N���X���g���Ӗ����܂��B�p�����������o�ϐ��A�܂��̓��\�b�h���㏑���w�肵�܂��B
    self.image = @@yellowFlash2[0]
    self.x = x
    self.y = y
    self.target = Window # ����̃����_�[�E�^�[�Q�b�g�i�`��Ώہj�͍ŏ㕔���C����Window���g�B

    # �p�����������o�Ɋ܂܂�Ȃ������o�ϐ��� @ �����Ď����ō��܂��B�X�R�[�v�̓N���X�S�̂ł��B
    @Yellowflash2AniCount = 0  # �A�j���[�V�����p�J�E���^
    @frame = 0
    @cahrY0 = y
  end

  def update
    self.wait
  end


  def draw
    Window.draw_ex(self.x,self.y,@@yellowFlash2[@Yellowflash2AniCount/30],:angle => 0, :alpha => 255, :scalex => 1.0, :scaley => 1.0) #�ݒ�
  end

  def wait
    @Yellowflash2AniCount += 4
    if @Yellowflash2AniCount >= 120 #@Yellowflash2AniCount/30�̂R�O��@Yellowflash2AniCount+=4�̂S���|��������
      @Yellowflash2AniCount = 0
    end
  end


  # DXRuby �� Image �ɂ͕��A�������\�b�h��������Ă��邪�ASprite �ɂ͑��݂��Ȃ��炵���ł��B
  def width
    self.image.width
  end

  def height
    self.image.height
  end

  def set_pos(x, y)
    @x, @y = x, y
  end

end
=end

#�Q�[���N���A�A�j��

class Yellow_flash2 <Sprite

  #�摜�t�@�C��
  Yellowflash2 = "./image/pipo-btleffect150c.png"

  # �����̃A�j���摜����ׂ��X�v���C�g�E�V�[�g�̓ǂݍ��݂ƃt���[���ւ̕����𓯎��ɍs���B
  # @@ �̓N���X���̍ł��O���̕ϐ��ɕt���܂��B�X�R�[�v�i�L���͈́j�̓N���X���S�̂ő啶���p�����[�^�Ɠ��`�ł��B
  @@yellowFlash2 = Image.load_tiles(Yellowflash2, 1, 5, true) # �����͏c���̕������ł��B

  # ���������\�b�h�inew �ł��̃N���X�̃I�u�W�F�N�g�������炦������Ɉ�x�������s����郁�\�b�h�ł��j�B
  def initialize(x, y) # x, y �� new �ŃI�u�W�F�N�g�쐬���̈����i�I�u�W�F�N�g�̏o���ʒu�ł��j�B

    # self �͂��̃N���X���g���Ӗ����܂��B�p�����������o�ϐ��A�܂��̓��\�b�h���㏑���w�肵�܂��B
    self.image = @@yellowFlash2[0]
    self.x = x
    self.y = y
    self.target = Window # ����̃����_�[�E�^�[�Q�b�g�i�`��Ώہj�͍ŏ㕔���C����Window���g�B

    # �p�����������o�Ɋ܂܂�Ȃ������o�ϐ��� @ �����Ď����ō��܂��B�X�R�[�v�̓N���X�S�̂ł��B
    @Yellowflash2AniCount = 0  # �A�j���[�V�����p�J�E���^
    @frame = 0
    @cahrY0 = y
  end

  def update
    self.wait
  end


  def draw
    Window.draw_ex(self.x,self.y,@@yellowFlash2[@Yellowflash2AniCount/30],:angle => 0, :alpha => 255, :scalex => 1.0, :scaley => 1.0) #�ݒ�
  end

  def wait
    @Yellowflash2AniCount += 4
    if @Yellowflash2AniCount >= 120 #@Yellowflash2AniCount/30�̂R�O��@Yellowflash2AniCount+=4�̂S���|��������
      @Yellowflash2AniCount = 0
    end
  end


  # DXRuby �� Image �ɂ͕��A�������\�b�h��������Ă��邪�ASprite �ɂ͑��݂��Ȃ��炵���ł��B
  def width
    self.image.width
  end

  def height
    self.image.height
  end

  def set_pos(x, y)
    @x, @y = x, y
  end

end
#=end

=begin
class Wind_beam <Sprite

  #�摜�t�@�C��
  Windbeam = "./image/Main_Scene2/pipo-btleffect148c.png"

  # �����̃A�j���摜����ׂ��X�v���C�g�E�V�[�g�̓ǂݍ��݂ƃt���[���ւ̕����𓯎��ɍs���B
  # @@ �̓N���X���̍ł��O���̕ϐ��ɕt���܂��B�X�R�[�v�i�L���͈́j�̓N���X���S�̂ő啶���p�����[�^�Ɠ��`�ł��B
  @@windBeam = Image.load_tiles(Windbeam, 1, 10, true) # �����͏c���̕������ł��B

  # ���������\�b�h�inew �ł��̃N���X�̃I�u�W�F�N�g�������炦������Ɉ�x�������s����郁�\�b�h�ł��j�B
  def initialize(x, y) # x, y �� new �ŃI�u�W�F�N�g�쐬���̈����i�I�u�W�F�N�g�̏o���ʒu�ł��j�B

    # self �͂��̃N���X���g���Ӗ����܂��B�p�����������o�ϐ��A�܂��̓��\�b�h���㏑���w�肵�܂��B
    self.image = @@windBeam[0]
    self.x = x
    self.y = y
    self.target = Window # ����̃����_�[�E�^�[�Q�b�g�i�`��Ώہj�͍ŏ㕔���C����Window���g�B

    # �p�����������o�Ɋ܂܂�Ȃ������o�ϐ��� @ �����Ď����ō��܂��B�X�R�[�v�̓N���X�S�̂ł��B
    @windAniCount = 0  # �A�j���[�V�����p�J�E���^
    @frame = 0
    @cahrY0 = y
  end

  def update
    self.wait
  end


  def draw
    Window.draw_ex(self.x,self.y,@@windBeam[@windAniCount/20],:angle => 0, :alpha => 255, :scalex => 1.0, :scaley => 1.0) #�ݒ�
  end

  def wait
    @windAniCount += 4
    if @windAniCount >= 200
      @windAniCount = 0
    end
  end


  # DXRuby �� Image �ɂ͕��A�������\�b�h��������Ă��邪�ASprite �ɂ͑��݂��Ȃ��炵���ł��B
  def width
    self.image.width
  end

  def height
    self.image.height
  end

  def set_pos(x, y)
    @x, @y = x, y
  end

end #�摜�̓ǂݍ���
=end

class Wind_beam <Sprite

  #�摜�t�@�C��
  Windbeam = "./image/Main_Scene2/pipo-btleffect148c.png"

  # �����̃A�j���摜����ׂ��X�v���C�g�E�V�[�g�̓ǂݍ��݂ƃt���[���ւ̕����𓯎��ɍs���B
  # @@ �̓N���X���̍ł��O���̕ϐ��ɕt���܂��B�X�R�[�v�i�L���͈́j�̓N���X���S�̂ő啶���p�����[�^�Ɠ��`�ł��B
  @@windBeam = Image.load_tiles(Windbeam, 1, 10, true) # �����͏c���̕������ł��B

  # ���������\�b�h�inew �ł��̃N���X�̃I�u�W�F�N�g�������炦������Ɉ�x�������s����郁�\�b�h�ł��j�B
  def initialize(x, y) # x, y �� new �ŃI�u�W�F�N�g�쐬���̈����i�I�u�W�F�N�g�̏o���ʒu�ł��j�B

    # self �͂��̃N���X���g���Ӗ����܂��B�p�����������o�ϐ��A�܂��̓��\�b�h���㏑���w�肵�܂��B
    self.image = @@windBeam[0]
    self.x = x
    self.y = y
    self.target = Window # ����̃����_�[�E�^�[�Q�b�g�i�`��Ώہj�͍ŏ㕔���C����Window���g�B

    # �p�����������o�Ɋ܂܂�Ȃ������o�ϐ��� @ �����Ď����ō��܂��B�X�R�[�v�̓N���X�S�̂ł��B
    @windAniCount = 0  # �A�j���[�V�����p�J�E���^
    @frame = 0
    @cahrY0 = y
  end

  def update
    self.wait
  end


  def draw
    Window.draw_ex(self.x,self.y,@@windBeam[@windAniCount/20],:angle => 0, :alpha => 255, :scalex => 1.0, :scaley => 1.0) #�ݒ�
  end

  def wait
    @windAniCount += 4
    if @windAniCount >= 200
      @windAniCount = 0
    end
  end


  # DXRuby �� Image �ɂ͕��A�������\�b�h��������Ă��邪�ASprite �ɂ͑��݂��Ȃ��炵���ł��B
  def width
    self.image.width
  end

  def height
    self.image.height
  end

  def set_pos(x, y)
    @x, @y = x, y
  end

end

# �e�X�g�E�R�[�h
# �N���X�E�t�@�C���̒P�̃e�X�g
# ���ڂ��̃t�@�C���𑖂点���ꍇ�Ɏ��s�����R�[�h
if __FILE__ == $0

  Window.bgcolor = C_WHITE #�����Ŏ��s���Ă���
  encount = Yellow_flash2.new(0, 0)
  Window.loop do
    Sprite.update(encount)
    Sprite.draw(encount)
  end
end
