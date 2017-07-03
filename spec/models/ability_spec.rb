require 'rails_helper'

RSpec.describe Ability do
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { should be_able_to :read, Quiz }
    it { should_not be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user) { create(:user) }
    let(:quiz) { create(:quiz, user: user) }
    let(:other_user) { create(:user) }
    let(:quiz_other_user) { create(:quiz, user: other_user) }

    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }

    context 'Quiz' do
      it { should be_able_to :create, Quiz }
      it { should be_able_to :update, quiz, user: user }
      it { should_not be_able_to :update, quiz_other_user, user: user }
      it { should be_able_to :destroy, quiz, user: user }
      it { should_not be_able_to :destroy, quiz_other_user, user: user }
      it { should be_able_to :statistics, quiz, user: user }
      it { should_not be_able_to :statistics, quiz_other_user, user: user }
    end

    context 'Question' do
      let(:question) { create(:question, quiz: quiz) }
      let(:question_other_user) { create(:question, quiz: quiz_other_user) }

      it { should be_able_to :create, Question }

      it "Can not create questions for another user's quiz" do
        expect(subject.can?(:create, quiz_other_user.questions.new)).to be_falsey
      end

      it { should be_able_to :update, Question }
      it { should_not be_able_to :update, question_other_user, user: user }

      it { should be_able_to :destroy, question, user: user }
      it { should_not be_able_to :destroy, question_other_user, user: user }
    end

    context 'Answer' do
      let(:question) { create(:question, quiz: quiz) }
      let(:question_other_user) { create(:question, quiz: quiz_other_user) }
      let(:answer) { create(:answer, question: question) }
      let(:answer_other_user) { create(:answer, question: question_other_user) }

      it { should be_able_to :create, Answer }

      it 'Can not create answers for quiz questions from another user' do
        expect(subject.can?(:create, question_other_user.answers.new)).to be_falsey
      end

      it { should be_able_to :update, answer, user: user }
      it { should_not be_able_to :update, answer_other_user, user: user }
      it { should be_able_to :destroy, answer, user: user }
      it { should_not be_able_to :destroy, answer_other_user, user: user }
    end

    context 'QuizApp' do
      let(:quiz_app) { create(:quiz_app, quiz: quiz) }
      let(:quiz_app_other_user) { create(:quiz_app, quiz: quiz_other_user) }

      it { should be_able_to :create, QuizApp }

      it "Can not create quiz_apps for another user's quiz" do
        expect(subject.can?(:create, quiz_other_user.quiz_apps.new)).to be_falsey
      end

      it { should be_able_to :update, QuizApp }
      it { should_not be_able_to :update, quiz_app_other_user, user: user }
    end

    context 'Point' do
      let(:point) { create(:point, quiz: quiz) }
      let(:point_other_user) { create(:point, quiz: quiz_other_user) }

      it { should be_able_to :create, Point }

      it "Can not create points for another user's quiz" do
        expect(subject.can?(:create, quiz_other_user.points.new)).to be_falsey
      end

      it { should be_able_to :update, Point }
      it { should_not be_able_to :update, point_other_user, user: user }

      it { should be_able_to :destroy, point, user: user }
      it { should_not be_able_to :destroy, point_other_user, user: user }
    end
  end
end
