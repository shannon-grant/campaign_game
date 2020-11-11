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
        self.my_campaigns.map do |g| 
            if g.charitable_campaign
            p "You've contributed $#{g.question.reward} to #{g.charitable_campaign}"
            else 
            p "You haven't contributed to any campaigns yet! Play a game to win money for charities."
            end 
        end 
    end

    def delete_account
        self.destroy
    end


end