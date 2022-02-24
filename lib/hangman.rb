require 'yaml'

def draw_hangman(guesses)
  case(guesses)
  when 0
    puts "+---+
    |   |
        |
        |
        |
        |"
  when 1
    puts "+---+
    |   |
    O   |
        |
        |
        |"
  when 2
    puts "+---+
    |   |
    O   |
   /    |
        |
        |"
  when 3
    puts "+---+
    |   |
    O   |
   /|   |
        |
        |"
  when 4
    puts "+---+
    |   |
    O   |
   /|\\  |
        |
        |"
  when 5
    puts "+---+
    |   |
    O   |
   /|\\  |
   /    |
        |" 
  when 6
    puts "+---+
    |   |
    O   |
   /|\\  |
   / \\  |
        |"                                     
  end
end

def word_select
  unselected = true
  while unselected
    line = rand(1000)
    bank = File.readlines("google-10000-english-no-swears.txt")
    word = bank[line]
      if word.length >= 5 && word.length <= 12
        unselected = false
      end
  end
  word
end

def save_game(word, guesses, word_display, used_letters)
  Dir.chdir "saves"
  puts Dir.pwd
  save_number = 1
  while File.exist?("save#{save_number}.yaml")
    save_number += 1
  end
  save_array = [word, guesses, word_display, used_letters]
  File.open("save#{save_number}.yaml", "w") { |file| file.write(save_array.to_yaml)}
  Dir.chdir ".."

end

def start_game
  word = word_select()
  word_display = Array.new(word.length - 1, "_")
  used_letters = Array.new(0)
  game_on = true
  guesses = 0
  while game_on
    draw_hangman(guesses)
    puts word_display.join(" ")
    puts "letters used: #{used_letters.join("-")}"
    awaiting_input = true
    while awaiting_input
      puts "please enter single letter guess or type 'save' to save progress: "
      input = gets.chomp.downcase
      if input == "save"
        save_game(word, guesses, word_display, used_letters)
        game_on = false
        break
      elsif input.length == 1 && !!(input =~ /[a-z]/)
        awaiting_input = false
      end
    end 
    used_letters.push(input)
    word.each_char.with_index {|c, i|
    if input == c
      word_display[i] = c
    end
    }
    unless word.include?(input)
      guesses += 1
    end 
    if guesses > 5
      game_on = false
      puts "you lose"
      draw_hangman(guesses)
      puts "the word was: #{word}"
      break
    elsif word_display.include?("_") == false
      game_on = false
      puts "you win"
      puts "the word was: #{word}"
      break
    end
  end
end

def load_game(save_file)
  Dir.chdir "saves"
  load_array = YAML.load(File.read(save_file))
  File.delete(save_file)
  Dir.chdir ".."
  word = load_array[0]
  guesses = load_array[1]
  word_display = load_array[2]
  used_letters = load_array[3]
  game_on = true
  
  while game_on
    draw_hangman(guesses)
    puts word_display.join(" ")
    puts "letters used: #{used_letters.join("-")}"
    awaiting_input = true
    while awaiting_input
      puts "please enter single letter guess or type 'save' to save progress: "
      input = gets.chomp.downcase
      if input == "save"
        save_game(word, guesses, word_display, used_letters)
        game_on = false
        break
      elsif input.length == 1 && !!(input =~ /[a-z]/)
        awaiting_input = false
      end
    end 
    used_letters.push(input)
    word.each_char.with_index {|c, i|
    if input == c
      word_display[i] = c
    end
    }
    unless word.include?(input)
      guesses += 1
    end 
    if guesses > 5
      game_on = false
      puts "you lose"
      draw_hangman(guesses)
      puts "the word was: #{word}"
      break
    elsif word_display.include?("_") == false
      game_on = false
      puts "you win"
      puts "the word was: #{word}"
      break
    end
  end
end  

def check_saves
  puts Dir.entries("saves")
end

def select_save
  puts "available games: "
  puts Dir.entries("saves")
  unselected = true
  while unselected
    puts "please enter name of game you wish to load: "
    save_input = gets.chomp
    if File.exist?("saves/#{save_input}")
      unselected = false
    end
  end
  load_game(save_input)
end

master_game_on = true

while master_game_on
  puts "HANGMAN\nplease select:\n1: new game\n2: load game\n3: exit"
  choice = gets.chomp
  case choice
  when "1"
    start_game()
  when "2"
    load_game(select_save())
  when "3"
    master_game_on = false
  end
end


