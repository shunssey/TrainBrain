require './lib/source/weighted_randomizer'

wr = WeightedRandomizer.new('queue1' => 10000, 'queue2' => 100, 'queue3' => 2)#wr�̑O��@��u���Ainit�̂Ƃ����
puts "Using queue #{wr.sample}"#wr�̑O��@��u���A�ǂ��ł��D���ȏ���
