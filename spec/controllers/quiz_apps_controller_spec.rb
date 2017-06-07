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

  describe 'PATCH #update' do
    let(:quiz) { create(:quiz) }
    let!(:quiz_app) { create(:quiz_app, quiz: quiz) }

    context 'Authenticated user' do
      context 'author quiz' do
        before { sign_in quiz.user }

        context 'with valid attributes' do
          it 'assings the requested quiz_app to @quiz_app' do
            patch :update, params: { id: quiz_app, quiz_app: attributes_for(:quiz_app), format: :js }
            expect(assigns(:quiz_app)).to eq quiz_app
          end

          it 'changes quiz_app attributes' do
            app_updated = {
              platform: 'new updated platform',
              app_id: 77_788_899,
              app_secret: 'new_update_secret'
            }
            patch :update, params: { id: quiz_app, quiz_app: app_updated, format: :js }
            quiz_app.reload
            expect(quiz_app.platform).to eq app_updated[:platform]
            expect(quiz_app.app_id).to eq app_updated[:app_id]
            expect(quiz_app.app_secret).to eq app_updated[:app_secret]
          end

          it 'render update template' do
            patch :update, params: { id: quiz_app, quiz_app: attributes_for(:quiz_app), format: :js }
            expect(response).to render_template :update
          end
        end

        context 'with invalid attributes' do
          before do
            patch :update, params: { id: quiz_app, quiz_app: { platoform: nil, app_id: nil, app_secret: nil }, format: :js }
          end

          it 'does not update the quiz_app' do
            expect(quiz_app.platform).not_to be_empty
            expect(quiz_app.app_id).not_to be_nil
            expect(quiz_app.app_secret).not_to be_empty
          end

          it 'render update template' do
            expect(response).to render_template :update
          end
        end
      end

      context 'User is not author' do
        let(:another_user) { create(:user) }
        let(:app_updated) { { platform: 'updated platform', app_id: 77_899, app_secret: 'new_update_secret' } }

        before do
          sign_in another_user
          patch :update, params: { id: quiz_app, quiz_app: app_updated, format: :js }
        end

        it 'try update quiz_app' do
          quiz_app.reload
          expect(quiz_app.platform).not_to eq app_updated[:platform]
          expect(quiz_app.app_id).not_to eq app_updated[:app_id]
          expect(quiz_app.app_secret).not_to eq app_updated[:app_secret]
        end

        it 'render forbidden template' do
          expect(response).to have_http_status(:forbidden)
          expect(response).to render_template 'errors/error_forbidden'
        end
      end
    end

    context 'Unauthorized user' do
      it 'try update quiz_app' do
        app_updated = {
          platform: 'new updated platform',
          app_id: 77_788_899,
          app_secret: 'new_update_secret'
        }
        patch :update, params: { id: quiz_app, quiz_app: app_updated, format: :js }
        quiz_app.reload
        expect(quiz_app.platform).not_to eq app_updated[:platform]
        expect(quiz_app.app_id).not_to eq app_updated[:app_id]
        expect(quiz_app.app_secret).not_to eq app_updated[:app_secret]
      end
    end
  end

  describe '#vkontakte' do
    let!(:user) { create(:user) }
    let(:quiz) { create(:quiz) }
    let!(:quiz_app) { create(:quiz_app, platform: 'vkontakte', quiz: quiz) }
    let!(:vk_params) { { auth_key: 'vk_auth_key', viewer_id: "789" } }
    let(:params) { { quiz_id: quiz.id, auth_key: vk_params[:auth_key], viewer_id: vk_params[:viewer_id] } }

    context 'Guest authenticate user' do
      before { guest_authorization_vkontakte(quiz_app, vk_params) }

      it 'receive api auth' do
        expect(@vkontakte_api).to receive(:auth).with(*@params).and_return(@auth)
        get :vkontakte, params: params
      end
    end

    context 'Authenticated user' do
      before do
        guest_authorization_vkontakte(quiz_app, vk_params)
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

  def guest_authorization_vkontakte(quiz_app, vk_params)
    @vkontakte_api = class_double('VkontakteApi').as_stubbed_const(transfer_nested_constants: true)
    @auth = double('auth').as_null_object
    @params = [
      quiz_app.app_id,
      quiz_app.app_secret,
      vk_params[:auth_key],
      vk_params[:viewer_id]
    ]
    allow(@auth).to receive(:provider).and_return('vkontakte')
    allow(@auth).to receive(:uid).and_return(vk_params[:viewer_id])
    allow(@auth).to receive(:info).and_return({})
    allow(@vkontakte_api).to receive(:auth).with(*@params).and_return(@auth)
  end
end
