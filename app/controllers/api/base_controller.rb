# app/controllers/api/base_controller.rb
class Api::BaseController < ApplicationController
  before_action :set_current_user
  include AuthHelper

  private

  def set_current_user
    token = request.headers['Authorization']&.split(' ')&.last
    if token.present?
      decoded_token = decode_jwt(token)
      user_id = decoded_token['id'] # 'user_id' ではなく 'id' を使用
      Rails.logger.info("Decoded user_id: #{user_id}") # user_idをログ出力
      @current_user = User.find_by(id: user_id)
      if @current_user.nil?
        render json: { error: 'User not found' }, status: :not_found
      end
    else
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  rescue JWT::DecodeError => e
    Rails.logger.error("JWT Decode Error: #{e.message}")
    Rails.logger.error("Invalid token: #{token}") if token.present?
    render json: { error: 'Unauthorized' }, status: :unauthorized
  rescue StandardError => e
    Rails.logger.error("Error setting current user: #{e.message}")
    render json: { error: 'Internal server error' }, status: :internal_server_error
  end
end
