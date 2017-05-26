#!/usr/bin/env ruby
# coding: utf-8

### conver dc-sweep data to count per dc-input-voltage
# INPUT : measured data output : 2 column := index <tab> 0110
# OUTPUT: column := VOLTAGE <tab> count(典型的には0から256までの数字など)

STDERR.puts <<EOS
前提 :
入力ファイルは４列 q3,q2,q1,q0の順番. 
q0が一番d0に近い方
data-flow: q3<-q2<-q1<-q0<-(d0)
EOS

# arr of [q3,q2,q1,q0]
def count(qarr)
  raise unless qarr.size == 260

  count = 0
  ### verify inputs
  # q3 q2 q1 q0
  # AA BB CC DD
  # BB CC DD 00
  # CC DD 00 00
  # DD 00 00 00
  # 00 00 00 00
  for i in 0..63    
    tobesame1 = [ qarr[i+64*3][0], qarr[i+64*2][1], qarr[i+64*1][2],  qarr[i+64*0][3] ]
    tobesame2 = [ qarr[i+64*2][0], qarr[i+64*1][1], qarr[i+64*0][2] ]
    tobesame3 = [ qarr[i+64*1][0], qarr[i+64*0][1] ]
    
    if true # true: raise
      raise "index:#{i},verify1 #{tobesame1}" unless tobesame1.uniq.size == 1
      raise "index:#{i},verify2 #{tobesame2}" unless tobesame2.uniq.size == 1
      raise "index:#{i},verify3 #{tobesame3}" unless tobesame3.uniq.size == 1      
    else
      puts "//MISS// index:#{f=i},verify1 #{tobesame1}" unless tobesame1.uniq.size == 1
      puts "//MISS//index:#{f=i},verify2 #{tobesame2}" unless tobesame2.uniq.size == 1
      puts "//MISS//index:#{f=i},verify3 #{tobesame3}" unless tobesame3.uniq.size == 1
      return nil if f
    end
    
  end
  for i in 256..259
    raise "redundant shoud be 0000, but actually, i=#{i}=>#{ qarr[i] }" unless qarr[i] == ["0","0","0","0"]
  end
  
  count = 0
  for i in 0..255 do
    raise "unexpected input in index=#{i}: #{qarr[i][0]}" unless ["0","1"].include?( qarr[i][0] )
    count += 1 if qarr[i][0] == "1"
  end
  return count, qarr[0,256].map{|e| e[0] }
  
end

def parse_measdata( unit=260 )
  
  counts , arrs = [], []

  ls = STDIN.readlines.reject{|l| l.chomp.empty? }
  raise unless ls.size % unit == 0
  run = ls.size / unit
  STDERR.puts "run=#{run}"

  run.times do |r|
    STDERR.puts "   processing run-index=#{r}" if r%1000==0
    q = []
    for line in ls[ unit*r, unit ]
      index, qq = line.split()
      q << qq.split("") # [q3,q2,q1,q0]
    end
    # raise unless gets.chomp.empty?
    run += 1
    count, arr = count(q)
    counts << count
    arrs << arr

  end
  return counts, arrs
end

if $0 == __FILE__
  cs ,as = parse_measdata()

  as.zip(cs).each do |array,count|
    puts [ count, array.join("") ].join("\t")
  end
  
end
