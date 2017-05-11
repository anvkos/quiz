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
    broadcast(:game_finished, game)
  end
end
