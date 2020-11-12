require 'pry'
@@prompt = TTY::Prompt.new

class User < ActiveRecord::Base
    has_many :games
    has_many :questions, through: :games

    def check_balance
        if self.account_balance == nil
            self.account_balance = 0
        end
        puts "Your account balance is #{self.account_balance}"
    end

    def my_campaigns
        Game.all.select do |g| 
            g.user == self
        end 
    end 

    def campaign_contributions
        
        if self.my_campaigns.any? == true 
            self.my_campaigns.map do |g| 
            #binding.pry
                if g.correct == true
                p "You've contributed $#{g.question.reward} to #{g.charitable_campaign}"
                else
                #binding.pry 
                #p "You haven't contributed to any campaigns yet! Play a game to win money for charities."
                #binding.pry
                end 
            end 
        else 
           p  "You havent played any games yet! Play a game to win money for a charity."
        end 

    end


    def delete_account
        self.destroy
    end

    def change_username
        self.username = @@prompt.ask("New username:")
        self.save
    end


end
