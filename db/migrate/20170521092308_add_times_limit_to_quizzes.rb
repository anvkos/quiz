class AddTimesLimitToQuizzes < ActiveRecord::Migration[5.1]
  def change
    add_column :quizzes, :once_per, :integer
    add_column :quizzes, :time_limit, :integer, default: 0
    add_column :quizzes, :time_answer, :integer, default: 0
    add_column :quizzes, :no_mistakes, :boolean, default: false
  end
end
