require './game_class.rb'
require 'yaml'

def load
  unless Dir.exist?('./saved_games')
    p 'You have no saved files'
    return
  end
  saved_games
  puts 'Write the name of the saved game you want to load'
  load_game = gets.chomp
  if File.exist?("./saved_games/#{load_game}.yaml")
    loaded_file = YAML.load(File.read("./saved_games/#{load_game}.yaml"))
    @letter_board = loaded_file['letter_board']
    @used_letters = loaded_file['used_letters']
    @total_lives = loaded_file['total_lives']
    @game_word = loaded_file['game_word']
    game_flow
  else
    p 'No saved game with that name, try again'
  end
end

def saved_games
  puts(Dir.glob('saved_games/*').map { |file| file[(file.index('m') + 4)...(file.index('.'))] })
end

def save_game
  Dir.mkdir('./saved_games') unless File.exist?('saved_games')
  puts 'Select a name to save your game: '
  save_name = gets.chomp
  File.open("./saved_games/#{save_name}.yaml", 'w'){ |file| file.write to_yaml}
  puts 'Game saved!'
end 

def to_yaml
  YAML.dump(
    'game_word' => @game_word,
    'letter_board' => @letter_board,
    'total_lives' => @total_lives,
    'used_letters' => @used_letters
  )
end