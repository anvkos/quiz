class CreateQuestionsGames < ActiveRecord::Migration[5.1]
  def change
    create_table :questions_games do |t|
      t.integer :game_id
      t.integer :question_id
      t.boolean :answer_correctly

      t.timestamps
    end

    add_index :questions_games, :game_id
    add_index :questions_games, :question_id
    add_index :questions_games, [:game_id, :question_id], unique: true
  end
end
