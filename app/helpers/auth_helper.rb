module AuthHelper
  def decode_jwt(token)
    decoded_token = JWT.decode(token, Rails.application.secrets.secret_key_base)
    Rails.logger.info("Decoded token: #{decoded_token}") # デコード結果をログ出力
    decoded_token[0]
  end
end
