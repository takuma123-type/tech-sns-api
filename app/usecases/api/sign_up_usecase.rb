class Api::SignUpUsecase < Api::Usecase
  class SignUpError < Api::Usecase::Error; end

  class Input < Api::Usecase::Input
    attr_accessor :email, :password
  end

  class Output < Api::Usecase::Output
    attr_accessor :user_id, :token
  end

  def sign_up
    user = User.new(email: input.email, password: input.password)
    if user.save
      token = user.generate_jwt
      Output.new(user_id: user.id, token: token)
    else
      raise SignUpError.new(user.errors.full_messages.join(', '))
    end
  end
end
