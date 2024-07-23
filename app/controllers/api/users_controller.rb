class Api::UsersController < Api::BaseController
  def show
    usecase = Api::GetUserDetailUsecase.new(
      input: Api::GetUserDetailUsecase::Input.new(id: params[:id])
    )
    @output = usecase.get
    render json: @output.user, status: :ok
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
          avatar: profile_params[:avatar],
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
    params.require(:profile).permit(:name, :avatar, :description)
  end

  def password_params
    params.require(:password).permit(:current_password, :new_password, :new_password_confirmation)
  end
end