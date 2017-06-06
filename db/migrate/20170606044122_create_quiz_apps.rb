class CreateQuizApps < ActiveRecord::Migration[5.1]
  def change
    create_table :quiz_apps do |t|
      t.references :quiz, foreign_key: true
      t.string :platform
      t.integer :app_id
      t.string :app_secret
      t.timestamps

      t.index [:platform, :app_id]
    end
  end
end
