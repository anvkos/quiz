class AddQuestionRandomlyToQuizzes < ActiveRecord::Migration[5.1]
  def change
    add_column :quizzes, :question_randomly, :boolean, default: false
  end
end
