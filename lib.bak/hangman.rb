# lib/hangman.rb

require_relative './game_objects'
require_relative './board'
require 'yaml'
require 'pry'

# Runs and connects all the game components
class Game
  include GameObjects
  include DrawingObjects

  def initialize
    @dictionary = Dictionary.new
    start
  end

  def start
    print "What's yer name?"
    player_name = gets.to_s
    @player = Player.new(player_name)
  end

  def play
    errors = 0
    until errors == @board.hangman.length
      if make_a_guess == false
        errors += 1
        board(false)
      else
        board(true)
      end
    end
  end

  private

  def board(error)
    p 'Running board'
    obscured_word = @dictionary.word
    hangman = Board.new(obscured_word)
    hangman.print(error)
  end

  def make_a_guess
    guess = @player.guess_word
    @dictionary.correct_guess?(guess) if guess.length == 1
    save if guess == 'save'
    true if guess == 'save'
  end

  def lose
    puts 'You have lost and have been hung.'
    puts 'Game Over...'
  end

  def save_game
    Dir.mkdir('saves') unless Dir.exist?('saves')
    save_file = File.open(filename, 'w')
    YAML.dump(game, save_file)
    save_file.close
    puts 'Game saved...'
  end

  def filename
    puts 'Type your save file name.'
    gets.chomp.downcase
  end
end

def start_game
  puts 'Hello, are you ready to play hangman?'
  puts 'Please start a new game or load a save if existing.'
  # File.open('saves/').each_with_index { |file, i| puts "#{i}: #{file}" }
  puts 'Please choose by number or type "start" to begin a new game.'
  begin
    choice = choose_a_game
  rescue StandardError
    puts 'Please choose a number.'
    choice = choose_a_game
  end

  case choice
  when 'start'
    game = Game.new
    game.play
    binding.pry
  when
    saved_game = File.open(File.join(Dir.pwd, choice), 'r')
    loaded_game = YAML.safe_load(saved_game)
    saved_game.close
    loaded_game
  end
end

def choose_a_game
  gets.chomp.to_s
end

def load_game
  saved = File.open(File.join(Dir.pwd, filename), 'r')
end

start_game
