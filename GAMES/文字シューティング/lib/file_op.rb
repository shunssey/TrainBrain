#!ruby -Ks


module File_operation
  #file���쐬�C������file�ɏ㏑���������Ƃ�
  def file_make(filename,data)
    f=File::open("#{filename}","w")
    f.puts "#{data}"
    f.close
  end
  
  #������file�ɒǉ��������Ƃ�
  def file_add(filename,data)
    f=File::open("#{filename}","a")
    f.puts "#{data}"
  end
  
  #������file��ǂݍ��ݔz���Ԃ�
  def file_load(filename,num=0)
    array = []
    open(filename) do |file|
      while l = file.gets
        array.push l.chomp.split(",") if num == 0  #1�s��1�z��Ƃ��C2�d�z����쐬�D��{�͂���D
        array.push l.chomp if num == 1             #1�s��1�P�ꂵ���Ȃ��ꍇ�͂���D
        array.push l.chomp.split(//s) if num==2    #1�s��1�P�ꂵ���Ȃ��C���f���Ƃɕ��������ꍇ�͂���(�قډ��C�ӎ��p)�D
      end
    end
    return array
  end
  
  #������file��ǂݍ��݁C�w�肵���v�f�̐���Ԃ�
  def file_search(filename,data)
    array = []
    open(filename) do |file|
      while l = file.gets
        array.push l.chomp.split(",")
      end
    end
    
    element=0
    for i in 0..array.size-1
      if array[i].include?(data)
        element+=1
      end
      #��d�z��ŏ����ꍇ�́C�u�ǂ̔z��̉��Ԗڂɂ���̂��v��m�肽���Ƃ�
      #for j in 0..array[i].size-1
      #  if array[i][j]==data
      #    element+=1
      #  end
      #end
    end
    return element
  end
  
  #������file��ǂݍ��݁C�w��̍s�̕��ϒl��Ԃ�
  def file_mean(filename,line)
    array = []
    open(filename) do |file|
      while l = file.gets
        array.push l.chomp.split(",")
      end
    end
    
    mean=0.000
    for i in 0..array.size-1
      mean=mean+array[i][line].to_i*1.000
    end
    mean=mean*1.000/array.size*1.000
    return mean
  end
  
end


#include File_operation
#file_add("test.txt","test,test1,test2")
#p file_mean("mean.txt",2)
#p file_search("test.txt","kore")
