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
end
