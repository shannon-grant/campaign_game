require 'pry'

class Question < ActiveRecord::Base
    has_many :games
    has_many :users, through: :games

    def self.make_reward
        self.all.map do |column|
            if column.difficulty == "easy"
            column.reward = 200
            column.save
            elsif column.difficulty == "medium"
            column.reward = 400
            column.save
            elsif column.difficulty == "hard"
            column.reward = 600
            column.save
            end 
        end 
    end 

end 