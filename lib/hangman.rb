# frozen_string_literal: true

# lib/hangman.rb require_relative './game_objects'

# Interconnets all game objects and controls the flow of the game for win and lose conditions
require_relative './game_objects'
require_relative './saveload'
require 'yaml'

# This controls the flow of the game, executing all relevant objects in one place
class Hangman
  include GameObjects
  include SaveLoad

  def initialize
    @dictionary = Dictionary.new
    @player = Player.new
    @board = Board.new
    @guesses = 0
  end

  # play, save_game, load_game are what runs the game
  def play
    end_game = false
    until @guesses == 6 || end_game == true
      guess = play_round(@player, @board, @dictionary.word)
      save if guess == 'save'
      update unless guess == 'save' || @dictionary.correct_letter?(guess)
      end_game = check_condition(@dictionary.word.split(''), '_')
      p @guesses
    end
  end

  private

  def play_round(player, board, word)
    board.print(word)
    player.guess
  end

  def save_game
    puts 'Please type in a filename for your save.'
    filename = gets.chomp.downcase
    save_data = YAML.dump(self)
    Dir.mkdir('saves') unless Dir.exist?('saves')
    File.open(File.join(Dir.pwd, "saves/#{filename}.yaml"), 'w') do |_file|
      puts save_data
    end
  end

  def load_game(filename)
    Hangman.new.play if filename == 'new'
    YAML.safe_load("saves/#{filename}")
  end

  # win, lose, update are the game conditions
  def win
    puts 'Congrats!'
    try_again
  end

  def lose
    puts 'Rough being dead.'
    try_again
  end

  def update
    @board.error
    @guesses += 1
  end

  def check_condition(word, string)
    if word.none?(string)
      win
    elsif word.any?(string) && @guesses == 6
      lose
    end
  end

  # controls the Hangman class creation for new or existing games
  def try_again
    puts 'Would you like to try again? y/n...'
    response = gets.chomp.downcase
    start_game if response == 'y'
  end
end

SaveLoad.start_game
