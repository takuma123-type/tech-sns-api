class Api::UpdatePasswordUsecase < Api::Usecase
  class UpdatePasswordError < Api::Usecase::Error; end

  class Input < Api::Usecase::Input
    attr_accessor :user, :current_password, :new_password, :new_password_confirmation

    def initialize(user:, current_password:, new_password:, new_password_confirmation:)
      @user = user
      @current_password = current_password
      @new_password = new_password
      @new_password_confirmation = new_password_confirmation
    end
  end

  class Output < Api::Usecase::Output
    attr_accessor :token

    def initialize(token:)
      @token = token
    end
  end

  def initialize(input:)
    @input = input
  end

  def update
    unless @input.user.authenticate(@input.current_password)
      raise UpdatePasswordError.new("Current password is incorrect")
    end

    if @input.new_password != @input.new_password_confirmation
      raise UpdatePasswordError.new("New password and confirmation do not match")
    end

    @input.user.password = @input.new_password

    if @input.user.save
      token = @input.user.generate_jwt
      Output.new(token: token)
    else
      raise UpdatePasswordError.new(@input.user.errors.full_messages.join(', '))
    end
  rescue => e
    Rails.logger.error("Password update failed: #{e.message}")
    raise UpdatePasswordError.new("Password update failed: #{e.message}")
  end
end