def opt1
  puts "Это тест\nВведите слово:"
  word = gets.chomp
  puts "Введите число:"
  num = gets.to_i
  if num < 7
    puts "#{word} увеличелось в #{num} раз"
  else
    puts "#{word} постарело на #{num} лет"
  end
end

def opt2
  puts "Введите число:"
  size = gets.to_i
  arr = [size]
  size.times do |i|
    i.times do |c|
      print "[#{arr[c]}]"
    end
    print "[*]"
    (size - i - 1).times do
      print "[]"
    end
    puts "\nВведите число:"
    arr[i] = gets.to_i
  end
end

loop do
  puts "1 - Тест, 2 - Массив, q - Выход"
  input = gets.chomp
  case input
  when "q"
    break
  when "1"
    opt1
  when "2"
    opt2
  end
end
