# frozen_string_literal: true

# lib/game_objects.rb

# The primary objects of the game: board, player, and the secret word
module GameObjects
  # Prints out the hangman string and current obfusticated word
  class Board
    def initialize
      @hangman = "\('_')/"
    end

    def print(word)
      puts word
      puts @hangman
    end

    def error
      @hangman.chop!
    end
  end

  # Allows the user to guess a letter
  class Player
    def guess
      print 'Please type in a response'
      response = gets.chomp.downcase
      if response == 'save'
        response
      elsif response.length > 1 # Only single character responses allowed
        guess
      else
        response
      end
    end
  end

  # Controls the word instance variable: generation, obfustication, and comparisons
  class Dictionary
    def initialize
      @word = generate_word
      @guesses = []
    end

    private

    def generate_word
      dictionary = File.open('dictionary.txt', 'r')
      word = dictionary.to_a.sample.chomp.downcase
      dictionary.close
      word
    end

    public

    def correct_letter?(guess)
      @guesses.push(guess)
      @word.split('').any?(guess)
    end

    def word
      censor = @word.split('').map.each do |letter|
        if @guesses.any?(letter)
          letter
        else
          '_'
        end
      end

      censor.join('')
    end
  end
end
