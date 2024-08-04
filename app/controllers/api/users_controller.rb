class Api::UsersController < Api::BaseController
  skip_before_action :verify_authenticity_token
  before_action :set_current_user, only: [:update_profile, :update_password, :destroy]

  def show
    token = request.headers['Authorization']&.split(' ')&.last
    Rails.logger.info("Token: #{token}")
    decoded_token = decode_token(token)
    Rails.logger.info("Decoded Token: #{decoded_token}")
    user_id = decoded_token['id'] if decoded_token
    Rails.logger.info("User ID: #{user_id}")

    if user_id
      usecase = Api::GetUserDetailUsecase.new(
        input: Api::GetUserDetailUsecase::Input.new(id: user_id)
      )
      @output = usecase.get
      render 'api/users/show', formats: [:json], handlers: [:jbuilder]
    else
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'User not found' }, status: :not_found
  rescue => e
    Rails.logger.error("Error: #{e.message}")
    render json: { error: 'Internal server error' }, status: :internal_server_error
  end

  def update_profile
    begin
      usecase = Api::UpdateProfileUsecase.new(
        input: Api::UpdateProfileUsecase::Input.new(
          user: @current_user,
          name: profile_params[:name],
          avatar: parse_base64_image(profile_params[:avatar]),
          description: profile_params[:description]
        )
      )
  
      output = usecase.update
      render json: { message: "Profile updated successfully", token: output.token }, status: :ok
    rescue => e
      Rails.logger.error("Profile update failed: #{e.message}")
      Rails.logger.error(e.backtrace.join("\n"))
      render json: { error: "Internal server error: #{e.message}" }, status: :internal_server_error
    end
  end

  def update_password
    begin
      usecase = Api::UpdatePasswordUsecase.new(
        input: Api::UpdatePasswordUsecase::Input.new(
          user: @current_user,
          current_password: password_params[:current_password],
          new_password: password_params[:new_password],
          new_password_confirmation: password_params[:new_password_confirmation]
        )
      )

      output = usecase.update
      render json: { message: "Password updated successfully", token: output.token }, status: :ok
    rescue => e
      Rails.logger.error("Password update failed: #{e.message}")
      Rails.logger.error(e.backtrace.join("\n"))
      render json: { error: "Internal server error: #{e.message}" }, status: :internal_server_error
    end
  end

  def destroy
    begin
      usecase = Api::DeleteUserUsecase.new(
        input: Api::DeleteUserUsecase::Input.new(user: @current_user)
      )

      usecase.delete
      render json: { message: "User deleted successfully" }, status: :ok
    rescue => e
      Rails.logger.error("User deletion failed: #{e.message}")
      Rails.logger.error(e.backtrace.join("\n"))
      render json: { error: "Internal server error: #{e.message}" }, status: :internal_server_error
    end
  end

  private

  def profile_params
    params.permit(:name, :avatar, :description)
  end
  

  def password_params
    params.require(:password).permit(:current_password, :new_password, :new_password_confirmation)
  end

  def decode_token(token)
    JWT.decode(token, Rails.application.secrets.secret_key_base)[0]
  rescue JWT::DecodeError => e
    Rails.logger.error("Token decode error: #{e.message}")
    nil
  end

def parse_base64_image(data)
  if data && data.match(%r{^data:(.*?);(.*?),(.*)$})
    image_data = data.split(',').last
    tempfile = Tempfile.new
    tempfile.binmode
    tempfile.write(Base64.decode64(image_data))
    tempfile.rewind
    tempfile
  else
    nil
  end
end
end
