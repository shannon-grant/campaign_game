
require 'pry'
require 'rest-client' 
require 'json'

Question.destroy_all
User.destroy_all
Game.destroy_all

api_resp = RestClient.get("https://opentdb.com/api.php?amount=50&type=multiple")
api_data = JSON.parse(api_resp)

def get_data(api_variable)
     api_variable.each do |k,v|
        if k == "results"
            v.each do |result|
              Question.create(option_1: result["incorrect_answers"][0], option_2: result["incorrect_answers"][1], answer: result["correct_answer"], option_3: result["incorrect_answers"][2], difficulty: result["difficulty"], prompt: result["question"] )
            end 
        end 
    end 
end 

api_resp2 = RestClient.get("https://opentdb.com/api.php?amount=50&type=multiple")
api_data2 = JSON.parse(api_resp2)

api_resp3 = RestClient.get("https://opentdb.com/api.php?amount=50&type=multiple")
api_data3 = JSON.parse(api_resp3)

api_resp4 = RestClient.get("https://opentdb.com/api.php?amount=50&type=multiple")
api_data4 = JSON.parse(api_resp4)

#First 50
get_data(api_data)
#Second 50 
get_data(api_data2)
#Third 50
get_data(api_data3)
#Last 50
get_data(api_data4)

Question.make_reward


