require 'pry'
class User < ActiveRecord::Base
    has_many :games
    has_many :questions, through: :games

    def check_balance
        puts "Your account balance is #{self.account_balance}"
    end

    def my_campaigns
        Game.all.select do |g| 
            g.user == self
        end 
    end 

    def campaign_contributions
        #all_contributions = 0

        if self.my_campaigns.any? == true 
            all_contributions = 0
            self.my_campaigns.map do |g| 
            #binding.pry
                if g.correct == true
                 all_contributions += g.question.reward 
                p "You've contributed $#{g.question.reward} to #{g.charitable_campaign}"
                sleep(2)
                else
                #binding.pry 
                #p "You haven't contributed to any campaigns yet! Play a game to win money for charities."
                #binding.pry
                end 
            end 
            p "Overall, you've given $#{all_contributions} to charity. You're a hero!"
        else 
           p "You havent played any games yet! Play a game to win money for a charity."
        end 

    end


    def delete_account
        self.destroy
    end


end
