class VkontakteApi
  def self.auth(app_id, app_secret, auth_key, viewer_id)
    params = {
      app_id: app_id,
      app_secret: app_secret,
      auth_key: auth_key,
      viewer_id: viewer_id
    }
    return nil unless auth_key_valid?(params)
    OpenStruct.new(
      provider: 'vkontakte',
      uid: params[:viewer_id],
      info: nil
    )
  end

  def self.auth_key_valid?(params)
    raw_key = "#{params[:app_id]}_#{params[:viewer_id]}_#{params[:app_secret]}"
    auth_key = Digest::MD5.hexdigest(raw_key)
    params[:auth_key] == auth_key
  end
end
