class CreateQuestionsTable < ActiveRecord::Migration[5.2]
  def change
    create_table :questions do |t|
    t.string :option_1
    t.string :option_2
    t.string :option_3
    t.string :option_4
    t.string :answer
    t.integer :reward
    t.string :difficulty
    t.string :prompt
    end
  end 
end
