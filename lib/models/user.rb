require 'pry'
class User < ActiveRecord::Base
    has_many :games
    has_many :questions, through: :games

    def check_balance
        self.account_balance
    end

    def my_campaigns
        Game.all.select do |g| 
            g.user == self
        end 
    end 

    def campaign_contributions
        self.my_campaigns.map do |g| g.charitable_campaign
        "You've contributed $#{g.question.reward} to #{g.charitable_campaign}"
        end 
    end

end