require './player_class'
require 'yaml'
require './save_mechanism.rb'

class Game
  attr_accessor :game_word, :words, :letter_board, :used_letters, :total_lives
  def initialize()
    @total_lives = 7
    @game_word = ''
    @words = []
    @letter_board = []
    @letter = ''
    game_menu
  end
  
  def game_menu()
    puts 'HANGMAN GAME'
    puts "\nDo you want to load a game or start a new one?"
    puts '(1) New Game'
    puts '(2) Load Game'
    option = gets.chomp
    while (option != "1" && option != "2")
      p 'Invalid input, select 1 or 2'
      option = gets.chomp
    end 
    if option == "1"
      puts "Enter your name: "
      @player1 = Player.new(gets.chomp.capitalize)
      puts "Welcome to Hangman, #{@player1.name}!"
      puts "\nYou have to guess the secret word by guessing letters in the word, and you have to guess the word before your lives run out. You have 5 lives"
      word_generator
      game_flow
    else
      load
    end
  end

  def word_generator
    @words = File.read('google-10000-english-no-swears.txt').split(/\n+/)
    possible_words = []
    @words.each {|word| possible_words.push(word) if word.length >= 8 && word.length <= 11}
    @game_word = possible_words.sample
    @letter_board = Array.new(@game_word.length, '_')
  end

  def game_flow
    puts "\nThe word is: "
    puts @letter_board.join(' ')
    puts "\n\nLet's see if you can guess it"
    player_turn
  end

  def player_turn
    @used_letters = []
    while @total_lives != 0
      puts "\n\nYOU HAVE #{@total_lives} LIVES LEFT " unless @total_lives == 1
      puts "\n\nYOU HAVE 1 LIVE LEFT" if @total_lives == 1
      puts "\n\nEnter a letter or type SAVE if you want to save your game"
      @letter = gets.chomp().downcase()
      if @letter == 'save'
        save_game
        exit
      elsif @letter == @game_word
        p 'You have won the game!'
        exit
      elsif @letter.length > 1
        puts "Sorry, enter just one letter or the complete word"
        puts @letter_board.join(' ')
      elsif @game_word.include?(@letter) && @used_letters.include?(@letter) == false
        @used_letters.push(@letter)
        board_update
      elsif @used_letters.include?(@letter)
        puts "\nYou have already used that letter, choose another one"
        puts @letter_board.join(' ')
      elsif @letter.length >= 2 && @letter != @game_word
        puts @letter_board.join(' ')
        @total_lives -= 1
      else
        @used_letters.push(@letter)
        puts "\nSorry, that letter is not in the word!"
        puts @letter_board.join(' ')
        @total_lives -= 1
      end
      win_check
      if @total_lives == 0
        game_over
      end
    end 
  end 

  def board_update
    nums = (0...@game_word.length).find_all { |i| @game_word[i] == @letter }
    nums.each { |i| @letter_board[i] = @letter }
    puts @letter_board.join(' ')
  end

  def win_check
    p 'You have won the game', exit if @letter_board.join == @game_word
    p @letter_board.join if @letter_board.join == @game_word
  end

  def game_over
    p 'You have lost'
    p "The word was #{game_word}! Try again next time"
    exit
  end
end 