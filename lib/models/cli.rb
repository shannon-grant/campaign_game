require 'tty-prompt'
require 'pry'
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

    def run
        welcome
        login_or_signup
    end


    def play_game

        def create_a_game

        end

        def game_won

        end

        def game_lost

        end

    end 

    def welcome
        puts "Hello! Welcome to Campaign Game!"
        sleep(1)
    end

    def login_or_signup
        prompt = TTY::Prompt.new
        # puts "Please enter your username to log in or sign up!"
        # uname = gets.chomp.downcase
        # puts "Please enter your password:"
        # pword = gets.chomp
        # @user = User.find_or_create_by(username: uname, password: pword, account_balance: 0)
        # puts "Welcome #{@user.username.capitalize}!"
        #binding.pry
        puts "Log in or Create A New Account"
        
        uname = prompt.ask("Please Enter Your Username:").downcase
        pword = prompt.mask("Please Enter Your Password:", required: true)
        @user = User.find_or_create_by(username: uname, password: pword)
        puts "Welcome #{@user.username.capitalize}!"

        # uname = prompt.ask("Please Enter Your Username:")
        # user = User.find_by(user: uname)
        
    end


    def main_menu

    end
end




