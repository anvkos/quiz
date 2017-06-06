class VkontakteApi
  def self.auth_key_valid?(quiz_app, api_params)
    raw_key = "#{quiz_app.app_id}_#{api_params[:viewer_id]}_#{quiz_app.app_secret}"
    auth_key = Digest::MD5.hexdigest(raw_key)
    api_params[:auth_key] == auth_key
  end

  def self.auth(params)
    OpenStruct.new({
      provider: "vkontakte",
      uid: params[:viewer_id],
      info: params
    })
  end
end
