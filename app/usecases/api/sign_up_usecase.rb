class Api::SignUpUsecase < Api::Usecase
  class Input
    attr_accessor :email, :password

    def initialize(email:, password:)
      @email = email
      @password = password
    end
  end

  class Output
    attr_accessor :token

    def initialize(token:)
      @token = token
    end
  end

  class SignUpError < StandardError; end

  def initialize(input:)
    @input = input
  end

  def sign_up
    Rails.logger.info("Creating user with email: #{@input.email}")

    user = User.new(email: @input.email, password: @input.password)
    if user.save
      token = user.generate_jwt
      Output.new(token: token)
    else
      Rails.logger.error("User creation failed: #{user.errors.full_messages.join(', ')}")
      raise SignUpError.new(user.errors.full_messages.join(", "))
    end
  end
end
