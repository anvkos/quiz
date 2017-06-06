require 'rails_helper'

RSpec.describe QuizAppsController, type: :controller do
  describe 'POST #create' do
    context 'Authenticated user' do
      let(:quiz) { create(:quiz) }

      context 'author quiz' do

        before { sign_in quiz.user }

        context 'with valid attributes' do
          it 'saves the new quiz_app in the database' do
            expect do
              post :create, params: { quiz_id: quiz, quiz_app: attributes_for(:quiz_app), format: :js }
            end.to change(quiz.quiz_apps, :count).by(1)
          end

          it 'render create template' do
            post :create, params: { quiz_id: quiz, quiz_app: attributes_for(:quiz_app), format: :js }
            expect(response).to render_template :create
          end
        end

        context 'with invalid attributes' do
          it 'does not save the quiz_app' do
            expect do
              post :create, params: { quiz_id: quiz, quiz_app: attributes_for(:quiz_app, :invalid), format: :js }
            end.to_not change(QuizApp, :count)
          end

          it 'render create template' do
            post :create, params: { quiz_id: quiz, quiz_app: attributes_for(:quiz_app, :invalid), format: :js }
            expect(response).to render_template :create
          end
        end
      end

      context 'User is not author quiz' do
        let(:another_user) { create(:user) }

        before { sign_in another_user }

        it 'Not saved the new quiz_app in the database' do
          expect do
              post :create, params: { quiz_id: quiz, quiz_app: attributes_for(:quiz_app), format: :js }
            end.to_not change(Question, :count)
        end

        it 'render forbidden template' do
          post :create, params: { quiz_id: quiz, quiz_app: attributes_for(:quiz_app), format: :js }
          expect(response).to have_http_status(:forbidden)
          expect(response).to render_template 'errors/error_forbidden'
        end
      end
    end
  end

  describe '#vkontakte' do
    let!(:user) { create(:user) }
    let(:quiz) { create(:quiz) }
    let!(:quiz_app) { create(:quiz_app, platform: 'vkontakte', quiz: quiz) }
    let!(:vk_params) { {auth_key: 'vk_auth_key', viewer_id: "789"} }
    let(:params) { { quiz_id: quiz.id, auth_key: vk_params[:auth_key], viewer_id: vk_params[:viewer_id] } }

    context 'Guest authenticate user' do
      before { guest_authorization_vkontakte(vk_params) }

      it 'receive api auth_key_valid?' do
        expect(@vkontakte_api).to receive(:auth_key_valid?).with(quiz_app, @params)
        get :vkontakte, params: params
      end

      it 'receive api auth' do
        expect(@vkontakte_api).to receive(:auth).with(@params).and_return(@auth)
        get :vkontakte, params: params
      end

      it 'receive api auth_key_valid?' do
      end
    end

    context 'Authenticated user' do
      before do
        guest_authorization_vkontakte(vk_params)
        get :vkontakte, params: params
      end

      it 'returns status success' do
        expect(response).to have_http_status(:success)
      end

      it 'render template' do
        expect(response).to render_template :vkontakte
      end
    end
  end

  def guest_authorization_vkontakte(vk_params)
    @vkontakte_api = class_double('VkontakteApi').as_stubbed_const(transfer_nested_constants: true)
    @params = ActionController::Parameters.new(vk_params).permit!
    allow(@vkontakte_api).to receive(:auth_key_valid?).with(quiz_app, @params).and_return(true)
    allow(@vkontakte_api).to receive(:auth_key_valid?).with(quiz_app, nil).and_return(false)
    @auth = double('auth').as_null_object
    allow(@auth).to receive(:provider).and_return('vkontakte')
    allow(@auth).to receive(:uid).and_return(vk_params[:viewer_id])
    allow(@auth).to receive(:info).and_return({})
    allow(@vkontakte_api).to receive(:auth).with(@params).and_return(@auth)
  end
end
