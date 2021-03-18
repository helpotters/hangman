# frozen_string_literal: true

# lib/saveload.rb

# Allows the user to safely load and save the game
module SaveLoad
  def save
    puts 'Please type in a filename for your save.'
    filename = gets.chomp.downcase
    save_data = YAML.dump(self)
    Dir.mkdir('saves') unless Dir.exist?('saves')
    File.open(File.join(Dir.pwd, "saves/#{filename}.yaml"), 'w') do |_file|
      puts save_data
    end
  end

  def load_game(game)
    YAML.load(game)
  end

  def check_dir
    case Dir.exist?('saves')
    when true
      puts Dir.entries('saves')
      puts "Type 'new' or the name of an old save..."
      gets.chomp.downcase
    when false
      'new_game'
    end
  end

  def start_game
    answer = check_dir
    if %w[new_game new].include?(answer)
      Hangman.new.play
    else
      load_game(answer)
    end
  end
end
