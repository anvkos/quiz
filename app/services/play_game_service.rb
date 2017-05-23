class PlayGameService
  include Wisper::Publisher

  def perform(answer, user)
    quiz = answer.question.quiz
    game = Game.where(user: user, quiz: quiz).last
    return nil unless game_exists?(game)
    return nil if game_finished?(game)
    check_answer(game, answer)
    question = game.choose_question
    finish_game(game) if question.nil?
    game.questions_games.create(question: question)
    question
  end

  private

  def game_exists?(game)
    return true unless game.nil?
    broadcast(:game_not_found)
    false
  end

  def game_finished?(game)
    if game.finished?
      broadcast(:game_finished, game)
      return true
    end
    time_game_over?(game)
  end

  def check_answer(game, answer)
    if answer.correct?
      game.increment!(:score)
    end
  end

  def time_game_over?(game)
    return false unless time_limit_expired?(game) || time_answer_expired?(game)
    finish_game(game)
    true
  end

  def finish_game(game)
    rating = Rating.find_by(user_id: game.user_id, quiz_id: game.quiz_id)
    rating.update(max_score: game.score) if rating.max_score.to_i < game.score
    game.update(finished: true)
    broadcast(:game_finished, game)
  end

  def time_limit_expired?(game)
    game.quiz.time_limit.positive? && game.created_at.to_i + game.quiz.time_limit.to_i < Time.now.to_i
  end

  def time_answer_expired?(game)
    game.quiz.time_answer.positive? && game.questions_games.last.created_at.to_i + game.quiz.time_answer.to_i < Time.now.to_i
  end
end
