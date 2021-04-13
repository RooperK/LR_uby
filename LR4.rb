module Resource
  def connection(routes)
    if routes.nil?
      puts "No route matches for #{self}"
      return
    end

    loop do
      print 'Choose verb to interact with resources (GET/POST/PUT/DELETE) / q to exit: '
      verb = gets.chomp
      break if verb == 'q'

      action = nil

      if verb == 'GET'
        print 'Choose action (index/show) / q to exit: '
        action = gets.chomp
        break if action == 'q'
      end


      action.nil? ? routes[verb].call : routes[verb][action].call
    end
  end
end

class PostsController
  extend Resource
  attr_reader :posts

  def initialize
    @posts = []
  end

  def find_post(id)
    if @posts.any?
      @posts.each do |(key, text)|
        if key == id
          return text
        end
      end
    end
    nil
  end

  def index
    if @posts.any?
      @posts.each do |(key, text)|
        puts "Post #{key}\n#{text}\n\n"
      end
      return
    end
    puts 'No posts'
  end

  def show
    puts 'Enter post ID:'
    id = gets.chomp.to_i
    if @posts.any?
      @posts.each do |(key, text)|
        if key == id
          puts "Post #{id}:\n#{text}\n\n"
          return
        end
      end
    end
    puts 'No posts found'
  end

  def create
    puts 'Enter post text:'
    text = gets.chomp
    if text.empty?
      puts 'Post can\'t be empty'
      return
    end
    max = -1
    @posts.each do |(key, post)|
      if key > max
        max = key
      end
    end
    max += 1
    @posts.append([max, text])
    puts "Post ID:#{max}"
  end

  def update
    puts 'Enter post ID:'
    id = gets.chomp.to_i
    if @posts.any?
      post = nil
      index = 0
      @posts.each_with_index do |(key, text), i|
        if key == id
          post = text
          index = i
          break
        end
      end
      if !post.nil?
        puts "Post #{id}:\n#{post}\n\n"
        puts 'Edit post:'
        @posts[index][1] = gets.chomp
        return
      end
    end
    puts 'No posts found'
  end

  def destroy
    puts 'Enter post ID:'
    id = gets.chomp.to_i
    if @posts.any?
      post = nil
      index = 0
      @posts.each_with_index do |(key, text), i|
        if key == id
          post = text
          index = i
          break
        end
      end
      if !post.nil?
        puts "Post #{id} deleted:\n#{post}\n\n"
        @posts.delete_at(index)
        return
      end
    end
    puts 'No posts found'
  end
end

class CommentsController
  extend Resource

  def initialize(pc)
    @posts_controller = pc
    @comments = []
  end

  def index
    if @comments.any?
      @comments.each do |(post, key, text)|
        puts "Comment #{key} post #{post}:#{text}\n\n"
      end
      return
    end
    puts 'No comments'
  end

  def show
    puts 'Enter post ID:'
    post_id = gets.chomp.to_i
    puts 'Enter comment ID:'
    id = gets.chomp.to_i
    @comments.each do |(post, key, text)|
      if key == id && post == post_id
        puts "Comments #{id}, post #{post}:#{text}\n\n"
        return
      end
    end
    puts 'No comments found'
  end

  def create
    puts 'Enter post ID:'
    id = gets.chomp.to_i
    if @posts_controller.find_post(id) == nil
      puts 'No post found'
      return
    end
    puts 'Enter comment text:'
    text = gets.chomp
    if text.empty?
      puts 'Comment can\'t be empty'
      return
    end
    max = -1
    @comments.each do |(_, key, _)|
      if key > max
        max = key
      end
    end
    max += 1
    @comments.append([id, max, text])
    puts "Comment ID:#{max}"
  end

  def update
    puts 'Enter comment ID:'
    id = gets.chomp.to_i
    if @comments.any?
      comment = nil
      index = 0
      @comments.each_with_index do |(key, text), i|
        if key == id
          comment = text
          index = i
          break
        end
      end
      if !comment.nil?
        puts "Comment #{id}:\n#{post}\n\n"
        puts 'Edit comment:'
        @comments[index][1] = gets.chomp
        return
      end
    end
    puts 'No comments found'
  end

  def destroy
    puts 'Enter comment ID:'
    id = gets.chomp
    if @comments.any?
      comment = nil
      index = 0
      @comments.each_with_index do |(key, text), i|
        if key == id
          comment = text
          index = i
          break
        end
      end
      if !comment.nil?
        puts "Comment #{id} deleted:\n#{comment}\n\n"
        @comments.delete_at(index)
        return
      end
    end
    puts 'No comments found'
  end
end

class Router
  def initialize
    @routes = {}
  end

  def init
    pc = PostsController.new
    resources(pc, 'posts')
    resources(CommentsController.new(pc), 'comments')

    loop do
      print 'Choose resource you want to interact (1 - Posts, 2 - Comments, q - Exit): '
      choice = gets.chomp

      PostsController.connection(@routes['posts']) if choice == '1'
      CommentsController.connection(@routes['comments']) if choice == '2'
      break if choice == 'q'
    end

    puts 'Good bye!'
  end

  def resources(controller, keyword)
    @routes[keyword] = {
      'GET' => {
        'index' => controller.method(:index),
        'show' => controller.method(:show)
      },
      'POST' => controller.method(:create),
      'PUT' => controller.method(:update),
      'DELETE' => controller.method(:destroy)
    }
  end
end

router = Router.new

router.init

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

=begin
loop do
  account = CashMoney.new

  unless account.mainLoop
  end
  break
end
=end
