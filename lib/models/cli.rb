require 'tty-prompt'
require 'pry'
require 'rest-client'  
require 'json' 


class CLI
    @@prompt = TTY::Prompt.new
    @@user = nil

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
def run
    system('clear')
    puts "Welcome to The Campaign game"
    self.class.main_menu
end 

def self.main_menu
    #Should bring up the main menu 
    system('clear')
    menu_choices = {"Start Game": 1, "Check Balance": 2, "Check Charitable Campaigns": 3, "Delete Account": 4}
    #binding.pry
    user_action = @@prompt.select("What would you like to do? (Use ↑/↓ arrow keys, press Enter to select)", menu_choices)
        case user_action
        when 1
            puts "You chose to start a game"
             self.play_game
        when 2
            user.check_balance
        when 3
            user.campaign_contributions
        when 4
            user.delete_account
        end
end 

def self.play_game
    user_action = @@prompt.select("Which charitable cause would you like to play for?") do |prompt|
        prompt.choice "Clean Water"
        prompt.choice "Poverty Alleviation"
        prompt.choice "COVID Relief"
        prompt.choice "World Peace"
    end 

    case user_action
    when "Clean Water"
       # binding.pry
        puts "You chose to play for Clean Water!"
    when "Poverty Alleviation"
        puts "You chose to play for Poverty Alleviation!"
    when "COVID Relief"
        puts "You chose to play for COVID Relief!"
    when "World Peace"
        puts "You chose to play for World Peace!"
    end 

    campaign = user_action

    Game.new(charitable_campaign: campaign)
    #binding.pry
end 


# def play_game

# Game.new()
#     def create_a_game

#     end
    
#     def game_won

#     end

#     def game_lost

#     end

# end 

# def login

# end

# def main_menu

# end

 end 


