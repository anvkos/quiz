class PlayGameService
  include Wisper::Publisher

  def perform(answers, user)
    quiz = answers.first.question.quiz
    game = Game.where(user: user, quiz: quiz).last
    return nil unless game_exists?(game)
    return nil if game_finished?(game)
    corrects = answers.map { |answer| check_answer(game, answer) }
    return nil if finish_answer_incorrect?(game, corrects)
    question = game.choose_question
    if question.nil?
      finish_game(game)
      return nil
    end
    game.questions_games.create(question: question)
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
    return false unless answer.correct?
    score = calculate_score(game)
    game.increment!(:score, score)
    true
  end

  def calculate_score(game)
    question = game.questions_games.last
    time_answer = Time.now.to_i - question.created_at.to_i
    points = game.quiz.points
    if points.present?
      time_points = points.sort_by(&:time).select { |point| point.time >= time_answer }
      return time_points.first.score
    end
    return 1 unless game.quiz.time_answer.positive?
    score = game.quiz.time_answer.to_i - time_answer
    [score, 1].max
  end

  def finish_answer_incorrect?(game, corrects)
    if corrects.include?(false) && game.quiz.no_mistakes?
      finish_game(game)
      return true
    end
    false
  end

  def time_game_over?(game)
    return false unless time_points_expired?(game) || time_limit_expired?(game) || time_answer_expired?(game)
    finish_game(game)
    true
  end

  def finish_game(game)
    rating = Rating.find_by(user_id: game.user_id, quiz_id: game.quiz_id)
    rating.update(max_score: game.score) if rating.max_score.to_i < game.score
    game.update(finished: true)
    broadcast(:game_finished, game)
  end

  def time_points_expired?(game)
    time_points = game.quiz.points
    return false if time_points.blank?
    time_answer = Time.now.to_i - game.questions_games.last.created_at.to_i
    points = time_points.select { |point| point.time >= time_answer }
    return false if points.present?
    true
  end

  def time_limit_expired?(game)
    game.quiz.time_limit.positive? && game.created_at.to_i + game.quiz.time_limit.to_i < Time.now.to_i
  end

  def time_answer_expired?(game)
    game.quiz.time_answer.positive? && game.questions_games.last.created_at.to_i + game.quiz.time_answer.to_i < Time.now.to_i
  end
end
