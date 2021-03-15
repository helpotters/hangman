# res lib/board.rb

module DrawingObjects
  class Board
    attr_reader :hangman

    def initialize(word)
      @word = word
      @hangman = '\(._.)/'
    end

    def print(error)
      print_word
      print_hangman(error)
    end

    def print_word
      puts @word
    end

    def print_hangman(error)
      case error
      when true
        @hangman.split('').slice!(0, 1)
      when false
        puts 'Well done!'
      end
      puts @hangman
    end
  end
end
