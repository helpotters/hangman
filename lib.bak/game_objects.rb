# lib/game_object.rb

module GameObjects
  # Creates a word hidden from the player and only returns true or false

  attr_reader :guesses

  class Dictionary
    @@existing_word = []
    def initialize
      @dictionary = File.open('dictionary.txt').to_a
      @word = generate_new_word.chomp.downcase
      @guesses = []
    end

    private

    def generate_new_word
      new_word = @dictionary.sample.to_s

      case @@existing_word.any?(new_word)
      when true
        new_word = generate_new_word # start over
        @@existing_word.push(new_word)
      when false
        new_word
      end
    end

    def ask_if_match?(guess)
      @word.split('').any?(guess)
    end

    public

    def word
      word = @word.split('').each.map do |letter|
        case @guesses.any?(letter)
        when false
          letter = '_'
        when true
          letter
        end
      end
      word.join('').to_s
    end

    def correct_guess?(guess)
      case @guesses.any?(guess)
      when true
        puts "That's an existing guess. Executioner doesn't have all day!."
        false
      when false
        puts 'Seems correct.'
        ask_if_match?(guess)
        @guesses.push(guess)
        @guesses
      end
    end
  end

  # The guesser and the one to be hanged
  class Player
    def initialize(player_name)
      @player_name = player_name
    end

    def guess_word
      puts "What's a correct letter?"
      guess = gets.chomp.downcase
      if guess.length == 1
        guess
      else if guess == 'save'
        guess
      else
        guess_word
      end
    end
  end
end
