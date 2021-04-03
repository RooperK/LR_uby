def opt
  puts "Enter age:"
  age = gets.chomp.to_i
  l = 0
  a = 0
  if age > 0
    puts "Enter file name:"
    result = File.new("result.txt", "w")
    File.foreach("#{gets.chomp}.txt") do |line|
      l += 1
      if line.split(" ")[2].to_i == age
        result.puts("#{line}")
        a += 1
      end
    end
    result.close
  end
  if (l != 0 && l == a) || age < 0
    File.foreach("result.txt") do |line|
      puts "#{line}"
    end
    return false
  end
  true
end

class CashMoney
  def initialize
    @balance = 100.0
    @file = "balance.txt"
  end

  def mainLoop
    if File.exists?("balance.txt")
      @balance = File.read(@file).to_f
    else
      File.write(@file, @balance);
    end
    loop do
      puts "(D)eposit | (W)ithdraw | (B)alance | (Q)uit"
      system "clear"
      input = gets.chomp.downcase
      case input
      when "q"
        break
      when "b"
        puts "Balance:#{@balance}\nPress Enter key to continue"
        gets
      when "d"
        deposit
      when "w"
        withdraw
      else
        puts "Invalid command. Press Enter key to continue"
        gets
      end
    end
    false
  end

  def deposit
    loop do
      puts "Balance:#{@balance}"
      puts "Enter deposit amount:"
      input = gets.chomp.downcase
      if input == "q"
        system "clear"
        break
      end
      i = input.to_i
      if i <= 0
        puts "Deposit amount can't be less or equal 0"
      else
        @balance += i
        File.write(@file, @balance)
        puts "#{@balance} after operation.\nPress Enter to continue"
        gets
        break
      end
    end
  end
  def withdraw
    loop do
      puts "Balance:#{@balance}"
      puts "Enter withdraw amount:"
      input = gets.chomp.downcase
      if input == "q"
        system "clear"
        break
      end
      i = input.to_i
      if i <= 0
        puts "Withdraw amount can't be less or equal 0"
      else
        @balance -= i
        File.write(@file, @balance)
        puts "#{@balance} after operation.\nPress Enter to continue"
        gets
        break
      end
    end
  end
end

loop do
  account = CashMoney.new
  unless opt
  end

  unless account.mainLoop
  end
  break
end