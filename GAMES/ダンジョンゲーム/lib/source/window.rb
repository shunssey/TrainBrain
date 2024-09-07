command = "./lib/resolution/Resolution"
output = `#{command}`
#sleep(2)
puts output
=begin
resolution = output.chop.split(/,/)

Window_w = resolution[0].to_i
Window_h = resolution[1].to_i
=end
Window_w = 1024
Window_h = 768
Window.width  = Window_w
Window.height = Window_h
Window.bgcolor = Cream
Window.x = 0
Window.y = 0
Window.frameskip = true
Window.fps = 60

#‰ð‘œ“x‚Ì”ä—¦
=begin
$ratio_x = resolution[0].to_f / 1024.to_f
$ratio_y = resolution[1].to_f / 768.to_f
=end
$ratio_x = 1.0
$ratio_y = 1.0
