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


    def run
        welcome
        self.class.login_or_signup
    end

    def welcome
        puts "Hello! Welcome to Campaign Game!"
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
            #Cross reference username with xyz
        #puts "Log in or Create A New Account"
        when "No"
            self.sign_up
        end 

        # uname = prompt.ask("Please Enter Your Username:").downcase
        # pword = prompt.mask("Please Enter Your Password:", required: true)
        # @user = User.find_or_create_by(username: uname, password: pword)
        # puts "Welcome #{@user.username.capitalize}!"

        # uname = prompt.ask("Please Enter Your Username:")
        # user = User.find_by(user: uname)
        
    end

    @wrong_count = 0

    def self.login
        
        uname = @@prompt.ask("Please Enter Your Username:")
        pword = @@prompt.mask("Please Enter Your Password:")
        
        @@user = User.find_by(username: uname, password: pword)
        if @@user
            system('clear')
            #self.main_menu
        puts "Welcome Back #{@@user.username.capitalize}!"
        elsif @wrong_count < 3
            puts "Invalid username or password"
            @wrong_count += 1 
            self.login
        else
            puts "Too Many Attempts"
        end
    end

    def self.sign_up
        uname = @@prompt.ask("Please Enter Your Username:")
        pword = @@prompt.mask("Please Enter Your Password:")
        @@user = User.create(username: uname, password: pword)
        puts "Welcome #{@@user.username.capitalize}!"
        system('clear')
        puts "Going to main menu"
    end


    def main_menu

    end



    # def play_game

    #     def create_a_game

    #     end

    #     def game_won

    #     end

    #     def game_lost

    #     end

    # end 
end




