class Api::SessionsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    input = Api::AuthenticateUserUsecase::Input.new(email: params[:email], password: params[:password])
    usecase = Api::AuthenticateUserUsecase.new(input: input)
    
    if usecase.authenticate
      render json: { token: usecase.instance_variable_get(:@output).token }, status: :created
    else
      render json: { error: 'Invalid email or password' }, status: :unauthorized
    end
  rescue => e
    Rails.logger.error("Error: #{e.message}")
    render json: { error: 'Internal server error' }, status: :internal_server_error
  end
end
