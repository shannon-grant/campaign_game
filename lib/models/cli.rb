require 'tty-prompt'
require 'pry'
require 'rest-client'  
require 'json'
# - login
# - menu
# - mulitiple choice
# - mask for pwd

#login_choices = [Play Game, Check Balance, Check Charitable Campaigns, Delete Account]
#campaign_choices = [Clean Water, Poverty Alleviation, COVID Relief, World Peace]
# For Menu
# choices = {small: 1, medium: 2, large: 3}
# prompt.select("What size?", choices)
# For campaign choices
#prompt.select("Choose your campaign", %w(Scorpion Kano Jax))
class CLI

    @@prompt = TTY::Prompt.new
    @@user = nil
    @@artii = Artii::Base.new #:font => 'slant'


    def run
        welcome
        self.class.login_or_signup
    end

    def welcome
        a = Artii::Base.new
        puts a.asciify(" Welcome to Campaign Game!").bold.colorize(:white)
        self.class.charity_hands
        sleep(1)                                                                                                                                                                                                                                                                                                                                                                                                                                                               
    end
    

    def self.login_or_signup    
        user_action = @@prompt.select("Do you have an account?") do |prompt|
            prompt.choice "Yes"
            prompt.choice "No"
        end 

        case user_action
        when "Yes"
            self.login
        when "No"
            self.sign_up
        end 
        
    end

    @wrong_count = 0

    def self.login
        
        uname = @@prompt.ask("Please Enter Your Username:")
        pword = @@prompt.mask("Please Enter Your Password:")
        
        @@user = User.find_by(username: uname, password: pword)
        if @@user
            system `say "Welcome Back #{@@user.username}!"`
            system('clear')
            self.main_menu
            puts "Welcome Back #{@@user.username.capitalize}!"
           
        elsif @wrong_count < 3
            puts "Invalid username or password"
            @wrong_count += 1 
            self.login
        else
            puts "Too Many Attempts. Please create a new username and password."
            puts "Returning to login screen..."
            sleep(2)
            self.login_or_signup
        end
    end

    def self.sign_up
        uname = @@prompt.ask("Please Enter Your Username:")
        pword = @@prompt.mask("Please Enter Your Password:")
        @@user = User.create(username: uname, password: pword)
        puts "Welcome #{@@user.username.capitalize}!"
        system `say "Welcome #{@@user.username}!"`
        system('clear')
        self.main_menu
    end


    def self.main_menu
        system('clear')
        a = Artii::Base.new
        puts a.asciify("Campaign Game!").colorize(:white)
        menu_choices = {"Start Game": 1, "Check Balance": 2, "Check Charitable Campaigns": 3, "Delete Account": 4, "Change Username": 5}
        #binding.pry
        user_action = @@prompt.select("What would you like to do? (Use ↑/↓ arrow keys, press Enter to select)", menu_choices)
            case user_action
            when 1
                puts "You chose to start a game"
                 self.play_game
            when 2
                @@user.check_balance
                #binding.pry
                sleep(3)
                self.main_menu
            when 3
                #binding.pry
                @@user.campaign_contributions
                #binding.pry
                sleep(5)
                system('clear')
                self.main_menu
            when 4
                puts "I'm sorry to see you go but I hope to see you again soon."
                sleep(1)
                puts "Deleting your account..."
                @@user.delete_account
                puts "Returning you to the main menu..."
                sleep(1)
                self.login_or_signup
            when 5
                @@user.change_username
                sleep(2)
                self.main_menu
            end

    end 

    def self.play_game
        if @@user.account_balance == nil 
        @@user.account_balance = 0
        @@user.save
        end 

        user_action = @@prompt.select("Which charitable cause would you like to play for?") do |prompt|
            prompt.choice "Clean Water"
            prompt.choice "Poverty Alleviation"
            prompt.choice "COVID Relief"
            prompt.choice "World Peace"
            prompt.choice "Return to Main Menu"
        end 
    
        case user_action
        when "Clean Water"
           # binding.pry
            puts "You chose to play for Clean Water!"
            self.ask_question(user_action)
        when "Poverty Alleviation"
            puts "You chose to play for Poverty Alleviation!"
            self.ask_question(user_action)
        when "COVID Relief"
            puts "You chose to play for COVID Relief!"
            self.ask_question(user_action)
        when "World Peace"
            puts "You chose to play for World Peace!"
            self.ask_question(user_action)
            #binding.pry
        when "Return to Main Menu"
            self.main_menu
        end 
    end 
    

    @wrong_answers = 0
    @charity_money = 0
    @user_money = 0
    @game_rounds = 0


        def self.ask_question(user_action)
            while @wrong_answers < 2 && @game_rounds <= 5
            random_quest = Question.all.sample
            #binding.pry
            current_game = Game.create(charitable_campaign: user_action, correct: nil, user_id: @@user.id, question_id: random_quest.id)
                user_answer = @@prompt.select(random_quest.prompt) do |prompt|
                    prompt.choice random_quest.option_1
                    prompt.choice random_quest.option_2
                    prompt.choice random_quest.answer
                    prompt.choice random_quest.option_3
                end 

                round_money = (random_quest.reward * 0.10).to_f

                if user_answer == random_quest.answer
                    puts "Correct! That question was worth $#{random_quest.reward}"
                    sleep(1)
                    puts "You earned $#{round_money} this round"
                    sleep(1)
                    #round_money = (random_quest.reward * 0.10).to_f
                    @charity_money += random_quest.reward
                    @@user.account_balance += round_money
                    @@user.save
                    @game_rounds += 1
                    @user_money += round_money
                    current_game.correct = true
                    current_game.save
                    #@user_money += round_money
                    puts "You've earned $#{@user_money} this game."
                    sleep(1)
                    self.ask_question(user_action)
                elsif user_answer != random_quest.answer && @wrong_answers < 1
                    #round_money = (random_quest.reward * 0.10).to_f
                    @wrong_answers += 1
                    @game_rounds += 1
                    current_game.correct = false
                    current_game.save
                    puts "Unfortunately that answer is wrong. The correct answer was #{random_quest.answer}. You have #{2 - @wrong_answers} more try left."
                    sleep(2)
                    if @@user.account_balance > 0
                        #we don't want negative values
                        @@user.account_balance -= round_money
                        @@user.save
                        puts "You've lost #{round_money} this round"
                        sleep(1)
                    end 
                    @user_money -= round_money
                    puts "You've earned $#{@user_money} this game."
                    sleep(1)
                    self.ask_question(user_action)
                else
                    puts "Oooph! So close! The correct answer was #{random_quest.answer}."
                    sleep(2)
                    puts "You've run out of tries!"
                    sleep(1)
                    if @@user.account_balance > 0
                        #we don't want negative values
                        @@user.account_balance -= (random_quest.reward * 0.10).to_f
                        @@user.save
                        puts "You've lost #{round_money} this round"
                        sleep(1)
                    end 
                    #puts "You lost #{round_money}"
                    @user_money -= round_money
                    puts "You've earned $#{@user_money} this game."
                    sleep(1)
                    puts "Returning to main menu..."
                    sleep(3)
                    @wrong_answers = 0
                    @game_rounds = 0
                    @user_money = 0
                    current_game.correct = false
                    current_game.save
                    self.main_menu
                end 
            end 

            if @game_rounds > 5
                puts "Congratulations! You've made it past all #{@game_rounds} rounds."
                puts "Returning to main menu..."
                @game_rounds = 0
                @user_money = 0
                sleep(3)
                self.main_menu
            end
        end 
 
       
        def self.charity_hands

            puts "                                                                                             
            ./ossso/-`    ./ossso/-`                        `-:/++//:.    `-://+//:.              
          -ydmmmmmmmdy/`:ydmmmmmmmdy:                      :o:.`   `./o-`/+:.`   `./o-            
         :dmmmmmmmmmmmmydmmmmmmmmmmmd+                    ++`         `/+:          `s:           
  `..    hmmmmmmmmmmmmmmmmmmmmmmmmmmmd`   ..`      `..   `h                          .h    ..`    
 `ymd+  `mmmmmmmmmmmmmmmmmmmmmmmmmmmmm:  -dmh.    .s:s-  :s                           h`  ++:y`   
 :mmmy   dmmmmmmmmmmmmmmmmmmmmmmmmmmmm.  ommm+    +/ /o  .y                           d   y. s:   
 +mmmy   ommmmmmmmmmmmmmmmmmmmmmmmmmmh   ommms    s- :o   y.                         /o   y. ++   
 +mmmh   `hmmmmmmmmmmmmmmmmmmmmmmmmmd-   smmmy    y. :s   -s`                       -y`   h` /+   
 +mmmm`   `sdmmmmmmmmmmmmmmmmmmmmmmh-    hmmmy    y. .y    -s-                     /s`   `d  /+   
 +mmmm- .:-`/hmmmmmmmmmmmmmmmmmmmd+`.:- `dmmms    s-  h` -:.`+o.                 -o/`.:. -s  +/   
 .dmmms ymmho-/hdmmmmmmmmmmmmmmh+-+hmmd`+mmmm/    /o  ++`h-/o+-+o-            `:o/-++:/y s:  y.   
  ommmmo.smmmmy:-odmmmmmmmmmds:-sdmmmh-/dmmmy      y- `s/-s: .+o-:o+.       -++-:o/` /s.o+  ++    
   smmmmd+:ymmmmy:`:odmmmds/`-smmmmh//hmmmmy`      `y-  -s//s: `/o-`/++-.:++:`:s:  /s:+o.  /s     
    +mmmmmd/:dmmmmh:  ./-  -ymmmmd/-hmmmmms`        `s/   :s-/s  `/s-  -/.  :s:  `y:/s-  `o+      
     -hmmmmmhdmmmmmms     +mmmmmmdymmmmmd:            :s`   +oo    `o+     s/    .oo:   -y-       
      `smmmmmmmmmmmmm+   :mmmmmmmmmmmmmh.              .y-           s:   ++           /s`        
        +mmmmmmmmmmmmd`  hmmmmmmmmmmmms`                `s/          .h  `h           o+          
         /dmmmmmmmmmmm+ -mmmmmmmmmmmmo                    o+          s- ++          o/           
          :dmmmmmmmmmmy +mmmmmmmmmmm+                      ++         /+ y.        `s:            
           /mmmmmmmmmmh smmmmmmmmmms                        o:        :s h`        o/             
           -mmmmmmmmmmh smmmmmmmmmm+                        ++        :s h`        s-             
           -mmmmmmmmmmh smmmmmmmmmm+                        ++        :s h`        s-             
           `+ooooooooo: -oooooooooo.                        .++++++++++- :++++++++++`       
           ".colorize(:red)
        end
        
end



