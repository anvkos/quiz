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

  describe 'PATCH #update' do
    let(:quiz) { create(:quiz) }

    context 'valid attributes' do

      it 'assigns the requested quiz to @quiz' do
        patch :update, params: { id: quiz, quiz: attributes_for(:quiz), format: :js }
        expect(assigns(:quiz)).to eq quiz
      end

      it 'change quiz attributes' do
        updated = {
          title: 'updated title',
          description: 'updated description',
          rules: 'updated rules',
          starts_on: Time.zone.now + 1.hours,
          ends_on: Time.zone.now + 1.day
        }
        patch :update, params: { id: quiz, quiz: updated, format: :js }
        quiz.reload
        updated.each do |attr, value|
          expect(quiz.send(attr)).to eq value.to_s
        end
      end

      it 'render update template' do
        patch :update, params: { id: quiz, quiz: attributes_for(:quiz), format: :js }
        expect(response).to render_template :update
      end
    end

    context 'invalid attributes' do
      let(:expetced_data) { { title: "premier Title", description: 'premier description', rules: 'premier' } }
      let(:quiz) { create(:quiz, expetced_data) }

      before do
        patch :update, params: { id: quiz, quiz: { title: 'updated title', description: nil }, format: :js }
      end

      it 'does not update quiz' do
        quiz.reload
        expetced_data.each do |attr, value|
          expect(quiz.send(attr)).to eq value
        end
      end

      it 'render update template' do
        expect(response).to render_template :update
      end
    end
  end
end
