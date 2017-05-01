class CreateQuizzes < ActiveRecord::Migration[5.1]
  def change
    create_table :quizzes do |t|
      t.string :title
      t.string :description
      t.text :rules
      t.datetime :starts_on
      t.datetime :ends_on

      t.timestamps
    end
  end
end
