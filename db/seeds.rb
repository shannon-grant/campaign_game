
require 'pry'
require 'rest-client' 
require 'json'

Question.destroy_all
User.destroy_all
Game.destroy_all

api_resp = RestClient.get("https://opentdb.com/api.php?amount=50&type=multiple")
api_data = JSON.parse(api_resp)

     api_data.each do |k,v|
        if k == "results"
            v.each do |result|
              Question.create(option_1: result["incorrect_answers"][0], option_2: result["incorrect_answers"][1], answer: result["correct_answer"], option_3: result["incorrect_answers"][2], difficulty: result["difficulty"], prompt: result["question"] )
            end 
        end 
    end 
#binding.pry
api_resp1 = RestClient.get()

#t.string :option_1
    #t.string :option_2
    #t.string :option_3
    #t.string :answer
    #t.integer :reward
    #t.string :difficulty
    #t.string :prompt