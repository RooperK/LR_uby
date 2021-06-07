class CashMoney
  require 'socket'
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
    server = TCPServer.new(2048)
    while true
      client = server.accept
      request = client.gets
      puts request
      method, uri = request.split(' ')
      response = "HTTP/1.1"
      if method == "GET"
        uri, num = uri.split('?')
        case uri
        when "/balance"
          result = "#{response} 200 OK\n\n{balance:#{@balance}}"
        when "/withdraw"
          result = withdraw num
          result = "#{response} #{result[0]}\n\n#{result[1]}"
        when "/deposit"
          result = deposit num
          result = "#{response} #{result[0]}\n\n#{result[1]}"
        when "/quit"
          result = "#{response}\n\nChange da world. My final message. Goodbye"
          client.print result
          client.close
          break
        else
          result = "#{response} 404\n\nNot found"
        end
      end
      client.print result
      client.close
    end
  end

  def withdraw(input)
    i = input.to_i
    if i <= 0
      ['400 Bad Request', 'Withdraw amount can\'t be less or equal 0']
    else
      i = @balance - i
      if i >= 0
        @balance = i
        File.write(@file, i)
        ['200 OK', "#{@balance} after operation."]
      else
        ['400 Bad Request', 'Balance is too low to withdraw']
      end
    end
  end

  def deposit(input)
    i = input.to_i
    if i <= 0
      ['400 Bad Request', 'Deposit amount can\'t be less or equal 0']
    else
      @balance += i
      File.write(@file, @balance)
      ['200 OK', "#{@balance} after operation."]
    end
  end
end

def main
  account = CashMoney.new

  account.mainLoop
end

main