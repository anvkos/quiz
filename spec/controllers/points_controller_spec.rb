require 'rails_helper'

RSpec.describe PointsController, type: :controller do
  let(:quiz) { create(:quiz) }

  describe 'POST #create' do
    context 'Authenticated user' do
      context 'author quiz' do

        before { sign_in quiz.user }

        context 'with valid attributes' do
          it 'saves the new point in the database' do
            expect do
              post :create, params: { quiz_id: quiz, point: attributes_for(:point), format: :js }
            end.to change(quiz.points, :count).by(1)
          end

          it 'render create template' do
            post :create, params: { quiz_id: quiz, point: attributes_for(:point), format: :js }
            expect(response).to render_template :create
          end
        end

        context 'with invalid attributes' do
          it 'does not save the point' do
            expect do
              post :create, params: { quiz_id: quiz, point: attributes_for(:point, :invalid), format: :js }
            end.to_not change(Point, :count)
          end

          it 'render create template' do
            post :create, params: { quiz_id: quiz, point: attributes_for(:point, :invalid), format: :js }
            expect(response).to render_template :create
          end
        end
      end

      context 'User is not author quiz' do
        let(:another_user) { create(:user) }

        before { sign_in another_user }

        it 'Not saved the new point in the database' do
          expect do
              post :create, params: { quiz_id: quiz, point: attributes_for(:point), format: :js }
            end.to_not change(Point, :count)
        end

        it 'render forbidden template' do
          post :create, params: { quiz_id: quiz, point: attributes_for(:point), format: :js }
          expect(response).to have_http_status(:forbidden)
          expect(response).to render_template 'errors/error_forbidden'
        end
      end
    end
  end

  describe 'PATCH #update' do
    let!(:point) { create(:point, quiz: quiz) }

    context 'Authenticated user' do
      context 'author quiz' do
        before { sign_in quiz.user }

        context 'with valid attributes' do
          it 'assings the requested point to @point' do
            patch :update, params: { id: point, point: attributes_for(:point), format: :js }
            expect(assigns(:point)).to eq point
          end

          it 'changes point attributes' do
            point_updated = {
              time: 33,
              score: 789,
            }
            patch :update, params: { id: point, point: point_updated, format: :js }
            point.reload
            expect(point.time).to eq point_updated[:time]
            expect(point.score).to eq point_updated[:score]
          end

          it 'render update template' do
            patch :update, params: { id: point, point: attributes_for(:point), format: :js }
            expect(response).to render_template :update
          end
        end

        context 'with invalid attributes' do
          before do
            patch :update, params: { id: point, point: { time: nil, score: nil }, format: :js }
          end

          it 'does not update the point' do
            expect(point.time).not_to be_nil
            expect(point.score).not_to be_nil
          end

          it 'render update template' do
            expect(response).to render_template :update
          end
        end
      end

      context 'User is not author' do
        let(:another_user) { create(:user) }
        let(:point_updated) { { time: 33, score: 789 } }

        before do
          sign_in another_user
          patch :update, params: { id: point, point: point_updated, format: :js }
        end

        it 'try update point' do
          point.reload
          expect(point.time).not_to eq point_updated[:time]
          expect(point.score).not_to eq point_updated[:score]
        end

        it 'render forbidden template' do
          expect(response).to have_http_status(:forbidden)
          expect(response).to render_template 'errors/error_forbidden'
        end
      end
    end

    context 'Unauthorized user' do
      it 'try update point' do
        point_updated = {
          time: 55,
          score: 789,
          app_secret: 'new_update_secret'
        }
        patch :update, params: { id: point, point: point_updated, format: :js }
        point.reload
        expect(point.time).not_to eq point_updated[:time]
        expect(point.score).not_to eq point_updated[:score]
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:point) { create(:point, quiz: quiz) }

    context 'Authenticated user' do
      context 'author quiz' do
        before { sign_in quiz.user }

        it 'delete point' do
          expect { delete :destroy, params: { id: point }, format: :js }.to change(Point, :count).by(-1)
        end

        it 'render destroy template' do
          delete :destroy, params: { id: point }, format: :js
          expect(response).to render_template :destroy
        end
      end

      context 'User is not the author' do
        let(:another_user) { create(:user) }
        before { sign_in another_user }

        it 'delete try point' do
          expect { delete :destroy, params: { id: point }, format: :js }.to_not change(Point, :count)
        end

        it 'render forbidden template' do
          delete :destroy, params: { id: point }, format: :js
          expect(response).to have_http_status(:forbidden)
          expect(response).to render_template 'errors/error_forbidden'
        end
      end
    end

    context 'Unauthorized user' do
      it 'delete point' do
        expect { delete :destroy, params: { id: point }, format: :js }.to_not change(Point, :count)
      end
    end
  end
end
