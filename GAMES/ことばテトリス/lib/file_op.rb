#!ruby -Ks


module File_operation
  #fileを作成，既存のfileに上書きしたいとき
  def file_make(filename,data)
    f=File::open("#{filename}","w")
    f.puts "#{data}"
    f.close
  end
  
  #既存のfileに追加したいとき
  def file_add(filename,data)
    f=File::open("#{filename}","a")
    f.puts "#{data}"
  end
  
  #既存のfileを読み込み配列を返す
  def file_load(filename,num=0)
    array = []
    open(filename) do |file|
      while l = file.gets
        array.push l.chomp.split(",") if num == 0  #1行を1配列とし，2重配列を作成．基本はこれ．
        array.push l.chomp if num == 1             #1行に1単語しかない場合はこれ．
        array.push l.chomp.split(//s) if num==2    #1行に1単語しかなく，音素ごとに分けたい場合はこれ(ほぼ音韻意識用)．
      end
    end
    return array
  end
  
  #既存のfileを読み込み，指定した要素の数を返す
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
      #二重配列で書く場合は，「どの配列の何番目にあるのか」を知りたいとき
      #for j in 0..array[i].size-1
      #  if array[i][j]==data
      #    element+=1
      #  end
      #end
    end
    return element
  end
  
  #既存のfileを読み込み，指定の行の平均値を返す
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
