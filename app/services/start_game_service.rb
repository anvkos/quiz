class StartGameService
  include Wisper::Publisher

  def perform(quiz, user)
    game = Game.create(quiz: quiz, user: user)
    question = game.choose_question
    return nil unless question_exists?(question)
    game.questions_games.create(question: question)
    # count games + 1 user.rating....
    question
  end

  private

  def question_exists?(question)
    return true unless question.nil?
    broadcast(:no_questions_quiz)
    false
  end
end
