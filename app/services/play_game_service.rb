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
    return false unless game.finished?
    broadcast(:game_finished, game)
    true
  end

  def check_answer(game, answer)
    if answer.correct?
      game.increment!(:score)
    end
  end

  def finish_game(game)
    rating = Rating.find_by(user_id: game.user_id, quiz_id: game.quiz_id)
    rating.update(max_score: game.score) if rating.max_score.to_i < game.score
    broadcast(:game_finished, game)
  end
end
