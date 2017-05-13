require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe "GET #ratings" do
    context 'Authenticated user' do
      sign_in_user

      it "returns http success" do
        get :ratings
        expect(response).to have_http_status(:success)
      end

      it 'render update template' do
        get :ratings
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
        expect(assigns(:quizzes)).to_not match_array(quizzes_other_user)
      end

      it 'render update template' do
        expect(response).to render_template :quizzes
      end
    end
  end
end
