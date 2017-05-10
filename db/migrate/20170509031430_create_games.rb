class CreateGames < ActiveRecord::Migration[5.1]
  def change
    create_table :games do |t|
      t.references :quiz, foreign_key: true
      t.references :user, foreign_key: true
      t.integer :score, default: 0
      t.boolean :finished, default: false

      t.timestamps
    end
  end
end
