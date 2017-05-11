class CreateRatings < ActiveRecord::Migration[5.1]
  def change
    create_table :ratings do |t|
      t.references :user, foreign_key: true
      t.references :quiz, foreign_key: true
      t.integer :count_games
      t.integer :max_score

      t.timestamps
    end
  end
end
