require "dxruby"
require "fileutils"


def save_picture(frame)
  begin
    x,y,w,h, * = frame
    picture = @screen.copy_rect(x,y,w,h)
    picture.save_bmp("save_tmp.bmp")
    transform_picture
    p "save_picture  fin"
    exit
  rescue=>error
    p error
    p "Error : in save_picture."
  end
end

def transform_picture
  bmp = Image.load("save_tmp.bmp")
  filename = File.basename($filename,".*")
  FileUtils.mkpath("out")
  bmp.save("out/#{filename}.jpg")
  File.delete("save_tmp.bmp")
end


