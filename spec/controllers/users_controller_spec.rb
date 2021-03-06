require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe "GET #quizzes" do
    let(:user) { create(:user) }
    let!(:quizzes) { create_list(:quiz, 2, user: user) }
    let!(:ratings) { create_list(:rating, 2, user: user) }
    let!(:ratings_other_user) { create_list(:game, 2) }
    let!(:quizzes_other_user) { create_list(:quiz, 2) }

    context 'Authenticated user' do
      before do
        sign_in user
        get :quizzes
      end

      it "returns http success" do
        expect(response).to have_http_status(:success)
      end

      it 'populates an array of user quizzes' do
        expect(assigns(:user_quizzes)).to match_array(quizzes)
      end

      it 'populates an array quizzes in which the user played' do
        member_quizzes = ratings.map(&:quiz)
        expect(assigns(:member_quizzes)).to match_array(member_quizzes)
      end

      it 'not populates an array of other user quizzes' do
        expect(assigns(:user_quizzes)).to_not match_array(Quiz.all)
      end

      it 'not populates an array quizzes of other user played' do
        expect(assigns(:member_quizzes)).to_not match_array(Quiz.all)
      end

      it 'render quizzes template' do
        expect(response).to render_template :quizzes
      end
    end
  end
end
