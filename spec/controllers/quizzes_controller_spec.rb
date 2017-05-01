require 'rails_helper'

RSpec.describe QuizzesController, type: :controller do
  describe "GET #new" do
    before { get :new }

    it 'returns http success' do
      expect(response).to have_http_status(:success)
    end

    it 'assigns a new Quiz to @quiz' do
      expect(assigns(:quiz)).to be_a_new(Quiz)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe "POST #create" do
    context 'with valid attributes' do
      it 'saves the new quiz in the database' do
        expect do
          post :create, params: { quiz: attributes_for(:quiz) }
        end.to change(Quiz, :count).by(1)
      end

      it 'redirects to shoq view' do
        post :create, params: { quiz: attributes_for(:quiz) }
        expect(response).to redirect_to quiz_path(assigns(:quiz))
      end
    end

    context 'with invalid attributes' do
      it 'does not save the quiz' do
        expect do
          post :create, params: { quiz: attributes_for(:quiz, :invalid) }
        end.to_not change(Quiz, :count)
      end

      it 're-rendes new view' do
        post :create, params: { quiz: attributes_for(:quiz, :invalid) }
        expect(response).to render_template :new
      end
    end
  end

  describe 'GET #show' do
    let(:quiz) { create(:quiz) }
    before { get :show, params: { id: quiz } }

    it 'assings the requested quiz to @quiz' do
      expect(assigns(:quiz)).to eq quiz
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end
end
