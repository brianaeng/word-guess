require 'io/console'
require 'rainbow'

class Game
  attr_accessor :mystery_word, :mystery_word_array, :blanks_array, :fish_tank, :letter, :counter
  def initialize
    # @mystery_word = ""
    @mystery_word_array = []
    @blanks_array = []
    @letter = letter
    @fish_tank = [
      Rainbow("
      ________________________________________________________________________________
                                                            \\  |                   /
                                                             \\_|__________________/
                                                                |
                                                                |
                                                                |
      ><(((º>                                                  ~J
      ________________________________________________________________________________").color(:blue),
      # #fish after 1 wrong guesses
      Rainbow("
      ________________________________________________________________________________
                                                              \\  |                   /
                                                                \\|__________________/
                                                                  |
                                                                  |
                                                                  |
       .·´¯`·.><(((º>                                            ~J
       ________________________________________________________________________________").color(:green),

      #fish after 2 wrong guesses
      Rainbow("
      ________________________________________________________________________________
                                                            \\  |                   /
                                                              \\|__________________/
                                                                |
                                                                |
                                                                |
      .·´¯`·..·´¯`·.><(((º>                                    ~J
      ________________________________________________________________________________").color(:greenyellow),

      #fish after 3 wrong guesses
      Rainbow("
      ________________________________________________________________________________
                                                            \\  |                   /
                                                              \\|__________________/
                                                                |
                                                                |
                                                                |
      .·´¯`·..·´¯`·..·´¯`·.><(((º>                             ~J
      ________________________________________________________________________________").color(:gold),

      #fish after 4 wrong guesses
      Rainbow("
      ________________________________________________________________________________
                                                            \\  |                   /
                                                              \\|__________________/
                                                                |
                                                                |
                                                                |
      .·´¯`·..·´¯`·..·´¯`·..·´¯`·.><(((º>                      ~J
      ________________________________________________________________________________").color(:orange),

      #fish after 5 wrong guesses
      Rainbow("
      ________________________________________________________________________________
                                                            \\  |                   /
                                                              \\|__________________/
                                                                |
                                                                |
                                                                |
      .·´¯`·..·´¯`·..·´¯`·..·´¯`·..·´¯`·.><(((º>               ~J
      ________________________________________________________________________________").color(:orangered),

      #fish after 6 wrong guesses
      Rainbow("
      ________________________________________________________________________________
                                                            \\  |                   /
                                                              \\|__________________/
                                                                |
                                                                |
                                                                |
      .·´¯`·..·´¯`·..·´¯`·..·´¯`·..·´¯`·..·´¯`·.><(((º>        ~J
      ________________________________________________________________________________").color(:red),

      #fish after 7 wrong guesses
      Rainbow("
      ________________________________________________________________________________
                                                            \\  |                   /
                                                              \\|__________________/
                                                                |
                                                                |
                                                                |
      .·´¯`·..·´¯`·..·´¯`·..·´¯`·..·´¯`·..·´¯`·..·´¯`·.><(((º> ~J
      ________________________________________________________________________________").color(:purple)]
      give_intro

  end #end of initialize

#Categorizes the difficulty of the word and tells the user the difficulty level
  def classify_word
    n = @mystery_word.chars.to_a.uniq.length # Num. unique chars in mystery_word
    #if there are less than five unique letters and the word includes the most commonly guessed letters, it's classified as 'easy'
    if n < 5 && @mystery_word =~ /[aerstln]/
      return @difficulty = "easy"
    #if all of the letters in the word are unique, and the word includes the least commonly guessed letters, it's classified as 'hard'
    elsif n == @mystery_word.length && @mystery_word =~ /[qjkwvxz]/
      return @difficulty = "hard"
    else
      return @difficulty = "medium"
    end
    puts "That is a(n) #{@difficulty} level word."
  end

#Introduces the game
  def give_intro
      puts "Welcome to Word Guess! It works like hangman."
      puts
      puts "Player 1 will be the  guesser."
      puts "Player 2, what do you want the mystery word to be? Please enter only letters."
      #Player 2 enters the mystery word, but this hides it so they can't see the word display in terminal
      @mystery_word = STDIN.noecho(&:gets).chomp
      #While the mystery word includes symbols or numbers, the user is prompted to enter a different word
        while @mystery_word =~ /[\W\d]/
          puts "Please try again and only enter letters."
          @mystery_word = STDIN.noecho(&:gets).chomp
        end
      #call the classify_word method and display the difficulty level
      classify_word
      #creates arrays for future use after the mystery_word is set
      @mystery_word_array = @mystery_word.split("")
      @blanks_array = @mystery_word_array.fill("_ ")
      puts
      puts "This is your fish: ><(((º> "
      puts
      puts "Try to prevent Fishy from being caught by the fisherman."
      puts
      puts @fish_tank[0] #Ascii fish are stored in an array, and this displays the first one
      puts
      puts "Every time you make an incorrect letter guess, Fishy will swim closer to the hook. If you're feeling lucky, you can guess a whole word; but, if you are wrong Fishy will swim toward danger. If Fishy reaches the hook, Fishy will be eaten. Good luck!"
      puts
      ask
    end

#ask the user to guess a letter
  def ask
    @counter = 0
    guesses = []
    #The game ends if the user guesses all of the correct letters before the counter runs out or they guess the whole word correctly. They get 7 guesses.
    until @blanks_array.join("") == mystery_word || @counter == (fish_tank.length-1) || @letter ==mystery_word
      puts @blanks_array.join("")
      puts "The letters you've guessed are: #{guesses.sort.join(", ")}"
      puts "Which letter(s) would you like to guess?"
      puts
      @letter = gets.chomp.downcase

      if @letter.length > 1
        whole_word_guessed
      #Handles inappropriate user input by redirecting the user if they enter a letter or symbol
      else
        alphabet_array = [*('a'..'z')]
        if alphabet_array.include? letter
          if guesses.include? letter
            puts "You've already guessed that letter!"
          else
            guesses.push(@letter)
            check_letter
          end #end of conditional to see if the letter has already been guessed
        else
          puts "You must guess a letter, a - z."
        end #end of conditional to see if user input is a letter
      end #end of conditional to see if they entered more than one letter

    end #end of until loop

    #This outputs whether the user lost or won
    if @counter == (@fish_tank.length-1)
      puts "Sorry, Fishy is for dinner!"
      puts "The word was #{@mystery_word}."
    else
      puts "Congratulations! You won! Fishy is safe."
      puts "The word was #{@mystery_word}."
    end#end of win or lose conditional
  end#end of ask method

  def check_letter
    if @mystery_word.include?(@letter)
        puts "Yes, there is at least one #{@letter} in the mystery word."
        if @mystery_word.count(@letter) > 1
          puts "Turns out there are #{@mystery_word.count(letter)} #{@letter}'s'"
          replace_letter
        else
          replace_letter
        end#end of the conditional to see if the guessed letter occurs more than once in the mystery word
      #displays ascii art to show the user that they guessed correctly
      puts @fish_tank[@counter]
      puts "Fishy stays in place."
      puts
      puts
    else
      wrong_guess
    end #end of conditional to see if the letter guessed is in the mystery_word
  end

#Replaces the blank with the corresponding letter
  def replace_letter
    indices_array = (0...@mystery_word.length).find_all { |i| @mystery_word[i] == "#{@letter}" }

    indices_array.each do |x|
    @blanks_array[x] = @letter
    end
  end

#Allow the program to accept the whole word as input from the user. If the word is guessed correctly, the user will win. Otherwise, it will be treated as another guess.
  def whole_word_guessed

    if @letter == mystery_word
      puts "You're a lucky guesser!"

    else
      puts "No, #{@letter} is not the mystery word."
        wrong_guess

      if @letter.length != mystery_word.length
        puts "Come on, count the blanks. Your guess doesn't even have the right number of letters."
      end

      if  @letter =~ /\d/ || @letter =~ /\W/
      puts "What do you have against Fishy?! Those aren't even letters!"
      end
    end #end of conditional to see if the whole word guessed is correct
  end #end of whole_world guessed method

  def wrong_guess
    @counter += 1
    puts @fish_tank[@counter]
    puts "Fishy swims toward danger!"
    puts
    puts
  end # end of wrong_guess method
end #end of class

test_game = Game.new

#Gives the user the option to continue playing
new_game = nil
until new_game == "no" || new_game == "n"
puts "Would you like to play again? Yes or no."
new_game = gets.chomp.downcase

  case new_game
    when  "yes", "y"
      Game.new
    when "no", "n"
      puts "Thanks for playing! Goodbye!"
    else
      puts "Hmmm? Would you like to play again? Yes or no."
      new_game = gets.chomp.downcase
  end
end
