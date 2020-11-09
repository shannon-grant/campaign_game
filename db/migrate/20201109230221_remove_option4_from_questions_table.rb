class RemoveOption4FromQuestionsTable < ActiveRecord::Migration[5.2]
  def change
    remove_column :questions, :option_4
  end
end
