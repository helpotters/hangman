# lib/hangman.rb
require_relative './game_objects'

# Interconnets all game objects and controls the flow of the game for win and lose conditions
class Hangman
  include GameObjects

  def initialize
    @dictionary = Dictionary.new
    @player = Player.new
    @board = Board.new
  end

  # play, save_game, load_game are what runs the game
  def play
    guesses = 0
    end_game = false
    until guesses == 7 || end_game == true
      guess = run_game(@player, @board, @dictionary.word)
      save_game if guess == 'save'
      update unless guess == 'save' || @dictionary.correct_letter? == false
      end_game = check_condition(@dictionary.word)
    end
  end

  private

  def run_game(player, board, word)
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
    Game.new if filename == 'new'
    YAML.safe_load("saves/#{filename}.yaml")
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
  end

  def check_condition; end

  # controls the Hangman class creation for new or existing games
  def try_again
    puts 'Would you like to try again? y/n...'
    response = gets.chomp.downcase
    start_game if response == 'y'
  end

  public

  def start_game
    if Dir.exist?('save')
      puts "Here's the existing saves, please type in the name or type 'new' for a new game."
      puts Dir.entries('save')
      filename = gets.chomp.downcase
      Hangman.load_game(filename).play

    else
      Hangman.new.play
    end
  end
end

game = Hangman.new
game.start_game
