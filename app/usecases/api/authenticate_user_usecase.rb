class Api::AuthenticateUserUsecase < Api::Usecase
  class Input < Api::Usecase::Input
    attr_accessor :email, :password
  end

  class Output < Api::Usecase::Output
    attr_accessor :token
  end

  def authenticate
    user = User.find_by(email: input.email)
    if user&.authenticate(input.password)
      token = user.generate_jwt
      @output = Output.new(token: token)
      @current_user = user
      true
    else
      false
    end
  end
end
