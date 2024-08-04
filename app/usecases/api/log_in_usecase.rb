class Api::LogInUsecase < Api::Usecase
  class LogInError < Api::Usecase::Error; end

  class Input < Api::Usecase::Input
    attr_accessor :email, :password
  end

  class Output < Api::Usecase::Output
    attr_accessor :token, :code

    def initialize(token:, code:)
      @token = token
      @code = code
    end
  end

  def log_in
    user = User.find_by(email: input.email)
    if user&.authenticate(input.password)
      token = user.generate_jwt
      Output.new(token: token, code: user.code)
    else
      raise LogInError.new("Invalid email or password")
    end
  end
end
