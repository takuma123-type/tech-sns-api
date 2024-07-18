class Api::SessionsController < Api::BaseController
  skip_before_action :verify_authenticity_token, only: [:sign_up, :log_in, :update_profile]
  skip_before_action :set_current_user, only: [:sign_up, :log_in]

  def sign_up
    usecase = Api::SignUpUsecase.new(
      input: Api::SignUpUsecase::Input.new(
        email: create_params[:email],
        password: create_params[:password]
      )
    )

    output = usecase.sign_up
    render json: { message: "User created successfully", token: output.token }, status: :created
  rescue Api::SignUpUsecase::SignUpError => e
    render json: { message: e.message }, status: :unprocessable_entity
  end

  def log_in
    usecase = Api::LogInUsecase.new(
      input: Api::LogInUsecase::Input.new(
        email: create_params[:email],
        password: create_params[:password]
      )
    )

    output = usecase.log_in
    render json: { message: "Logged in successfully", token: output.token }, status: :ok
  rescue Api::LogInUsecase::LogInError => e
    render json: { message: e.message }, status: :unprocessable_entity
  end

  def log_out
    @current_user = nil
    render json: { message: "Logged out successfully" }, status: :ok
  end

  def update_profile
    begin
      usecase = Api::UpdateProfileUsecase.new(
        input: Api::UpdateProfileUsecase::Input.new(
          user: @current_user,
          name: profile_params[:name],
          avatar: profile_params[:avatar],
          description: profile_params[:description]
        )
      )
  
      output = usecase.update
      render json: { message: "Profile updated successfully", token: output.token }, status: :ok
    rescue => e
      Rails.logger.error("Profile update failed: #{e.message}")
      Rails.logger.error(e.backtrace.join("\n")) # 追加: スタックトレースをログに出力
      render json: { error: "Internal server error: #{e.message}" }, status: :internal_server_error
    end
  end

  private

  def create_params
    params.require(:session).permit(:email, :password)
  end

  def profile_params
    params.permit(:name, :avatar, :description)
  end

  def authenticate_user!
    token = request.headers['Authorization']&.split(' ')&.last
    decoded_token = JWT.decode(token, Rails.application.secrets.secret_key_base)[0]
    @current_user = User.find_by(id: decoded_token['id'])
    render json: { error: 'Unauthorized' }, status: :unauthorized unless @current_user
  rescue JWT::DecodeError => e
    render json: { error: 'Unauthorized' }, status: :unauthorized
  end
end
