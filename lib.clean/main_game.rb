#!/usr/bin/env ruby
require_relative './game_objects'

require 'yaml'

module Game
  # Plays rounds of hangman
  class PlayHangman
    include GameControllers
    include GameSettings

    attr_reader :existing_guesses

    def initialize(words_list)
      @word = Word.new(words_list)
      @player = Player.new
      @hanger = Hanger.new
      @max_attempts = @hanger.hangman.length
      @existing_guesses = []
      puts "You can type 'save' during the response phase to save your game."
    end

    def play_round
      loop do
        puts @hanger.hangman
        guess = gets.chomp.downcase
        next if determine_input(guess) == false

        win if compare_guess(guess).none?('_')
        lose if @existing_guesses.length == (@max_attempts)
      end
    end

    def determine_input(input)
      case input
      when 'save'
        save_game?(input)
      when input.length > 1 || input.empty?
        false
      when input.length == 1
        @player.guess_single_letter
      end
    end

    def save_game?(input)
      if input == 'save'
        puts 'Please type in a filename'
        filename = gets.chomp.downcase
        save(filename)
        exit
      end
    end

    def compare_guess(guess)
      @existing_guesses.push(guess)
      puts @word.matching_characters(@existing_guesses).join('')
      @word.matching_characters(@existing_guesses)
    end
  end

  # Determines if a player wants to open a new game or old save
  class StartGame
    include GameSettings
    def startup
      puts "Would you like to start a 'new' game or load up an 'old' one?"
      puts 'What would you like to name your game, or what is the name of your old one?'
      response = gets.chomp.downcase
      load_game if response == 'old'
      new_game if response == 'new'
    end

    def load_game
      puts "What's the name of your save file? Select amongst the following list."
      puts Dir.entries('saves')
      filename = gets.chomp.downcase
      load_old_save(filename)
    end

    def new_game
      game = PlayHangman.new('dictionary.txt')
      game.play_round
    end
  end
end

game = Game::StartGame.new
game.startup
