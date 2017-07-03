class CreatePoints < ActiveRecord::Migration[5.1]
  def change
    create_table :points do |t|
      t.references :quiz, foreign_key: true
      t.integer :time, default: 0
      t.integer :score

      t.timestamps
    end
  end
end
