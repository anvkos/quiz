require 'rails_helper'

RSpec.describe PlayGameService do
  describe '#perform' do
    let!(:service) { PlayGameService.new }
    let(:user) { create(:user) }
    let(:quiz) { create(:quiz, created_at: 10.seconds.ago) }
    let(:game) { create(:game, quiz: quiz, user: user, created_at: 10.seconds.ago) }
    let(:question_one) { create(:question, quiz: quiz) }
    let!(:answer_question_one) { create(:answer, question: question_one) }
    let!(:rating) { create(:rating, user: user, quiz: quiz) }
    let!(:game_question) { game.questions_games.create(question: question_one, created_at: 10.seconds.ago) }

    it 'returns next question game' do
      question_two = create(:question, quiz: quiz)
      question_game = service.perform([answer_question_one], user)
      expect(question_game.question).to eq question_two
    end

    context 'score based option time_answer' do
      it 'score are increased by 1' do
        answer_question_one.correct = true
        answer_question_one.save
        score = game.score
        service.perform([answer_question_one], user)
        expect(game.reload.score).to eq (score + 1)
      end

      it 'score not increased' do
        score = game.score
        service.perform([answer_question_one], user)
        expect(game.reload.score).to eq score
      end

      context 'score depend on speed answer' do
        before do
          answer_question_one.correct = true
          answer_question_one.save
          @score = game.score
        end

        it 'speedy answer' do
          quiz.update(time_answer: 30)
          service.perform([answer_question_one], user)
          expect(game.reload.score).to eq @score + 20
        end

        it 'slow answer' do
          quiz.update(time_answer: 10)
          service.perform([answer_question_one], user)
          expect(game.reload.score).to eq @score + 1
        end
      end
    end

    context 'score based on time points' do
      before do
        answer_question_one.correct = true
        answer_question_one.save
        @score = game.score
      end

      it 'score one time point' do
        point = create(:point, quiz: quiz, time: 10, score: 100)
        service.perform([answer_question_one], user)
        expect(game.reload.score).to eq @score + point.score
      end

      it 'score between time points' do
        point_first = create(:point, quiz: quiz, time: 3, score: 100)
        point_second = create(:point, quiz: quiz, time: 20, score: 20)
        service.perform([answer_question_one], user)
        expect(game.reload.score).to eq @score + point_second.score
      end

      it 'no time points' do
        service.perform([answer_question_one], user)
        expect(game.reload.score).to eq @score + 1
      end
    end

    it 'create new record questions game' do
      create(:question, quiz: quiz)
      expect { service.perform([answer_question_one], user) }.to change(QuestionsGame, :count).by(1)
    end

    it 'publishes :game_not_found' do
      other_user = create(:user)
      expect { service.perform([answer_question_one], other_user) }.to broadcast(:game_not_found)
    end

    context 'publishes :game_finished' do
      context 'there are still questions' do
        let!(:question_two) { create(:question, quiz: quiz) }

        it 'game already finished' do
          game.finished = true
          game.save
          expect { service.perform([answer_question_one], user) }.to broadcast(:game_finished)
        end

        it 'game time expired' do
          time_limit = 8
          quiz.update(time_limit: time_limit)
          expect { service.perform([answer_question_one], user) }.to broadcast(:game_finished)
        end

        it 'time answer expired' do
          time_answer = 5
          quiz.update(time_answer: time_answer)
          expect { service.perform([answer_question_one], user) }.to broadcast(:game_finished)
        end

        it 'time points expired' do
          create(:point, quiz: quiz, time: 1)
          expect { service.perform([answer_question_one], user) }.to broadcast(:game_finished)
        end

        it 'incorrect answer' do
          no_mistakes = true
          quiz.update(no_mistakes: no_mistakes)
          expect { service.perform([answer_question_one], user) }.to broadcast(:game_finished)
        end
      end

      it 'no more questions' do
        expect { service.perform([answer_question_one], user) }.to broadcast(:game_finished)
      end
    end

    context 'update rating user' do
      let(:max_score) { 5 }

      before do
        game.update!(score: max_score)
      end

      it 'save max score' do
        service.perform([answer_question_one], user)
        expect(rating.reload.max_score).to eq max_score
      end

      it 'save max score game over by time_limit' do
        time_limit = 8
        quiz.update(time_limit: time_limit)
        service.perform([answer_question_one], user)
        expect(rating.reload.max_score).to eq max_score
      end

      it 'save max score game over by time_answer expired' do
        time_answer = 5
        quiz.update(time_answer: time_answer)
        service.perform([answer_question_one], user)
        expect(rating.reload.max_score).to eq max_score
      end

      it 'save max score - no_mistakes=true' do
        no_mistakes = true
        quiz.update(no_mistakes: no_mistakes)
        service.perform([answer_question_one], user)
        expect(rating.reload.max_score).to eq max_score
      end
    end

    it 'no update max score' do
      rating.update!(max_score: 5)
      game.update!(score: 3)
      service.perform([answer_question_one], user)
      expect(rating.reload.max_score).to eq 5
    end
  end
end
