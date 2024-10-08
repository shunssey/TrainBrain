#!ruby -Ks

module Romaji
 def to_Hiragana(inputed)
   re = nil
   case inputed
   when "a","A"
     re = "��"
   when "i","I", "yi","YI","wi","WI"
     re = "��"
   when "u","U","wu","WU"
     re = "��"
   when "e","E","ye","YE","we","WE"
     re = "��"
   when "o","O"
     re = "��"
   when "ka" , "ca", "KA","CA"
     re = "��"
   when "ki","KI"
     re = "��"
   when "ku" , "cu","KU","CU"
     re = "��"
   when "ke","KE"
     re = "��"
   when "ko" , "co","KO","CO"
     re = "��"
   when "sa","SA"
     re = "��"
   when "si" , "ci", "SI", "CI"
     re = "��"
   when "su", "SU"
     re = "��"
   when "se" , "ce", "SE", "CE"
     re = "��"
   when "so", "SO"
     re = "��"
   when "ta", "TA"
     re = "��"
   when "ti", "chi", "TI", "CHI"
     re = "��"
   when "tu", "tsu", "TU", "TSU"
     re = "��"
   when "te", "TE"
     re = "��"
   when "to", "TO"
     re = "��"
   when "na", "NA"
     re = "��"
   when "ni", "NI"
     re = "��"
   when "nu", "NU"
     re = "��"
   when "ne", "NE"
     re = "��"
   when "no", "NO"
     re = "��"
   when "ha", "HA"
     re = "��"
   when "hi", "HI"
     re = "��"
   when "hu" , "fu", "HU", "FU"
     re = "��"
   when "he", "HE"
     re = "��"
   when "ho", "HO"
     re = "��"
   when "ma", "MA"
     re = "��"
   when "mi", "MI"
     re = "��"
   when "mu", "MU"
     re = "��"
   when "me", "ME"
     re = "��"
   when "mo", "MO"
     re = "��"
   when "ya", "YA"
     re = "��"
   when "yu", "YU"
     re = "��"
   #when "ye", ""
   #  re = "����"
   when "yo", "YO"
     re = "��"
   when "ra", "RA"
     re = "��"
   when "ri", "RI"
     re = "��"
   when "ru", "RU"
     re = "��"
   when "re", "RE"
     re = "��"
   when "ro", "RO"
     re = "��"
   when "wa", "WA"
     re = "��"
   #when "wi"
   #  re = "����"
   #when "we"
   #  re = "����"
   when "wo","WO"
     re = "��"
   when "ga"
     re = "��"
   when "gi"
     re = "��"
   when "gu"
     re = "��"
   when "ge"
     re = "��"
   when "go"
     re = "��"
   when "za"
     re = "��"
   when "zi" , "ji"
     re = "��"
   when "zu"
     re = "��"
   when "ze"
     re = "��"
   when "zo"
     re = "��"
   when "da"
     re = "��"
   when "di"
     re = "��"
   when "du"
     re = "��"
   when "de"
     re = "��"
   when "do"
     re = "��"
   when "ba"
     re = "��"
   when "bi"
     re = "��"
   when "bu"
     re = "��"
   when "be"
     re = "��"
   when "bo"
     re = "��"
   when "pa"
     re = "��"
   when "pi"
     re = "��"
   when "pu"
     re = "��"
   when "pe"
     re = "��"
   when "po"
     re = "��"
   when "xa" , "la"
     re = "��"
   when "xi" , "li"
     re = "��"
   when "xu" , "lu"
     re = "��"
   when "xe" , "le"
     re = "��"
   when "lya", "xya"
     re = "��"
   when "lyu", "xyu"
     re = "��"
   when "lyo", "xyo"
     re = "��"
   when "xo" , "lo"
     re = "��"
   when "kya"
     re = "����"
   when "kyi"
     re = "����"
   when "kyu"
     re = "����"
   when "kye"
     re = "����"
   when "kyo"
     re = "����"
   when "sya" , "sha"
     re = "����"
   when "syi"
     re = "����"
   when "syu", "shu"
     re = "����"
   when "sye", "she"
     re = "����"
   when "syo", "sho"
     re = "����"
   when "tya","cha"
     re = "����"
   when "tyi"
     re = "����"
   when "tyu", "chu"
     re = "����"
   when "tye", "che"
     re = "����"
   when "tyo", "cho"
     re = "����"
   when "nya"
     re = "�ɂ�"
   when "nyu"
     re = "�ɂ�"
   when "nyo"
     re = "�ɂ�"
   when "hya"
     re = "�Ђ�"
   when "hyu"
     re = "�Ђ�"
   when "hyo"
     re = "�Ђ�"
   when "mya"
     re = "�݂�"
   when "myu"
     re = "�݂�"
   when "myo"
     re = "�݂�"
   when "rya"
     re = "���"
   when "ryu"
     re = "���"
   when "ryo"
     re = "���"
   when "gya"
     re = "����"
   when "gyu"
     re = "����"
   when "gyo"
     re = "����"
   when "zya", "ja"
     re = "����"
   when "zyi"
     re = "����"
   when "zyu", "ju"
     re = "����"
   when "zye", "je"
     re = "����"
   when "zyo", "jo"
     re = "����"
   when "dya"
     re = "����"
   when "dyi"
     re = "����"
   when "dyu"
     re = "����"
   when "dye"
     re = "����"
   when "dyo"
     re = "����"
   when "bya"
     re = "�т�"
   when "byi"
     re = "�т�"
   when "byu"
     re = "�т�"
   when "bye"
     re = "�т�"
   when "byo"
     re = "�т�"
   when "pya"
     re = "�҂�"
   when "pyi"
     re = "�҂�"
   when "pyu"
     re = "�҂�"
   when "pye"
     re = "�҂�"
   when "pyo"
     re = "�҂�"
   when "fa"
     re = "�ӂ�"
   when "fi"
     re = "�ӂ�"
   when "fe"
     re = "�ӂ�"
   when "fo"
     re = "�ӂ�"
   when "tha"
     re = "�Ă�"
   when "thi"
     re = "�Ă�"
   when "thu"
     re = "�Ă�"
   when "the"
     re = "�Ă�"
   when "tho"
     re = "�Ă�"
   when "dha"
     re = "�ł�"
   when "dhi"
     re = "�ł�"
   when "dhu"
     re = "�ł�"
   when "dhe"
     re = "�ł�"
   when "dho"
     re = "�ł�"
   when "ltu", "xtu", "ltsu", "xtsu"
     re = "��"
     @former_st = ""
   end
   return re
 end
end
