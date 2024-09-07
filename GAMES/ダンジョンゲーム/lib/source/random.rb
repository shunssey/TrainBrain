require './lib/source/weighted_randomizer'

wr = WeightedRandomizer.new('queue1' => 10000, 'queue2' => 100, 'queue3' => 2)#wrの前に@を置く、initのところに
puts "Using queue #{wr.sample}"#wrの前に@を置く、どこでも好きな所に
