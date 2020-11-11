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

    def won_games
        my_games = self.my_campaigns.select do |g| 
            g.correct == true
        end 
    end 


    def campaign_contributions
        if self.won_games.any? == true
            all_contributions = 0
            self.won_games.map do |g| 
                 all_contributions += g.question.reward 
                p "You've contributed $#{g.question.reward} to #{g.charitable_campaign}"
                sleep(2)
            end 
            p "Overall, you've given $#{all_contributions} to charity. You're a hero!"
        elsif self.my_campaigns.any? == false
           p "You havent played any games yet! Play a game to win money for a charity."
        else
        p "Unforunately you haven't won any money for charity. Keep playing and I'm sure you'll win soon!"
        end 
    end


    def delete_account
        self.destroy
    end


end
