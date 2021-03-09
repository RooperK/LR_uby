def opt1(str)
  num = str.split(" ")[0]
  if str.end_with?("CS")
    puts "#{2**str.length}"
  else
    puts str.reverse
  end
end

def opt2
  puts "Введите кол-во покемонов:"
  size = gets.to_i
  p = [size]
  size.times do |i|
    puts "Who's that pokemon?"
    pName = gets.chomp
    puts "Scope:"
    p[i] = {name: pName, scope: gets.chomp}
  end
  puts "["
  print "\t{name: #{(p[0])[:name]}, scope: #{p[0][:scope]}}"
  (size - 1).times do |i|
    print ",\n\t{name: #{p[i+1][:name]}, scope: #{p[i+1][:scope]}}"
  end
  puts "\n]"
end

loop do
  puts "1 - Word, 2 - Pokemon, q - Выход"
  input = gets.chomp
  case input
  when "q"
    break
  when "1"
    puts "Введите слово:"
    opt1(gets.chomp)
  when "2"
    opt2
  end
end
