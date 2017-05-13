require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe "GET #ratings" do
    let(:user) { create(:user) }
    let!(:ratings) { create_list(:rating, 2, user: user) }
    let!(:ratings_other_user) { create_list(:rating, 2) }

    context 'Authenticated user' do
      before do
        sign_in user
        get :ratings
      end

      it "returns http success" do
        expect(response).to have_http_status(:success)
      end

      it 'populates an array of user ratings' do
        expect(assigns(:ratings)).to match_array(ratings)
      end

      it 'not populates an array of other user ratings' do
        expect(assigns(:ratings)).to_not match_array(Rating.all)
      end

      it 'render update template' do
        expect(response).to render_template :ratings
      end
    end
  end

  describe "GET #quizzes" do
    let(:user) { create(:user) }
    let!(:quizzes) { create_list(:quiz, 2, user: user) }
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
        expect(assigns(:quizzes)).to match_array(quizzes)
      end

      it 'not populates an array of other user quizzes' do
        expect(assigns(:quizzes)).to_not match_array(Quiz.all)
      end

      it 'render update template' do
        expect(response).to render_template :quizzes
      end
    end
  end
end
