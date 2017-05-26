class StartGameService
  include Wisper::Publisher

  def perform(quiz, user)
    return nil if limited_frequency_games?(quiz, user)
    game = Game.create(quiz: quiz, user: user)
    question = game.choose_question
    return nil unless question_exists?(question)
    game.questions_games.create(question: question)
    increase_game_counter(game)
    question
  end

  private

  def question_exists?(question)
    return true unless question.nil?
    broadcast(:no_questions_quiz)
    false
  end

  def increase_game_counter(game)
    rating = Rating.find_or_create_by(user_id: game.user_id, quiz_id: game.quiz_id)
    rating.increment!(:count_games, 1)
  end

  def limited_frequency_games?(quiz, user)
    return false if quiz.once_per.blank?
    last_game = Game.where(user_id: user.id, quiz_id: quiz.id).last
    return false if last_game.nil?
    if last_game.created_at.to_i + quiz.once_per.to_i > Time.now.to_i
      broadcast(:error_frequent_game, quiz)
      return true
    end
    false
  end
end
