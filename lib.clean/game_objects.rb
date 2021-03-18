require 'yaml'

module GameControllers
  # Controls and generates the main word
  class Word
    def initialize(file)
      @word = File.open(file, 'r').to_a.sample.chomp.downcase
    end

    def matching_characters(chars)
      @word.split('').map do |letter|
        case chars.any?(letter)
        when true
          letter
        when false
          '_'
        end
      end
    end
  end

  # Controls the hangman person
  class Hanger
    attr_reader :hangman

    def initialize
      @hangman = "\(T_T)/ take me"
    end

    def print(word)
      puts word
      puts @hangman
    end

    def remove_limb
      @hangman.chop!
    end
  end

  # Queries the players response
  class Player
    def guess_single_letter(guess)
      guess_single_letter if guess.length > 1
    end
  end
end

# Controls attributes of the game
module GameSettings
  # simply ends the game one way or another
  def win
    puts 'You win!'
    exit
  end

  def lose
    puts 'You lose'
    exit
  end

  def save(filename)
    save_data = YAML.dump(self)
    Dir.mkdir('saves') unless Dir.exist?('saves')
    File.open(File.join(Dir.pwd, "saves/#{filename}.yaml"), 'w') do |_file|
      puts save_data
    end
  end

  def load_old_save(filename)
    YAML.safe_load("saves/#{filename}.yaml")
  end
end
