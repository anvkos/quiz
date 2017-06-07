require 'rails_helper'

RSpec.describe VkontakteApi do
  describe '.auth_key_valid?' do
    let(:params) { { app_id: 789, app_secret: 'app_secret', viewer_id: 778_899 } }

    it 'return true' do
      params[:auth_key] = Digest::MD5.hexdigest("#{params[:app_id]}_#{params[:viewer_id]}_#{params[:app_secret]}")
      expect(VkontakteApi.auth_key_valid?(params)).to eq true
    end

    it 'return false' do
      expect(VkontakteApi.auth_key_valid?(params)).to eq false
    end
  end

  describe '.auth' do
    let(:app_id) { 77_999 }
    let(:app_secret) { 'app_secret' }
    let(:viewer_id) { 888_999 }
    let(:auth_key) { Digest::MD5.hexdigest("#{app_id}_#{viewer_id}_#{app_secret}") }
    let!(:params) do
      {
        app_id: app_id,
        app_secret: app_secret,
        viewer_id: viewer_id,
        auth_key: auth_key
      }
    end

    it 'returns auth object' do
      auth = VkontakteApi.auth(app_id, app_secret, auth_key, viewer_id)
      expect(auth.provider).to eq 'vkontakte'
      expect(auth.uid).to eq params[:viewer_id]
      expect(auth.info).to eq params[:info]
    end

    it 'returns nil' do
      params[:auth_key] = 'invalid_key'
      expect(VkontakteApi.auth(app_id, app_secret, params[:auth_key], viewer_id)).to be_nil
    end
  end
end
