class CreateGamesTable < ActiveRecord::Migration[5.2]
  def change
    create_table :games do |t|
      t.string :charitable_campaign
      t.boolean :correct
      t.integer :user_id
      t.integer :question_id
    end
  end
end
