class Api::DeleteUserUsecase < Api::Usecase
  class DeleteUserError < Api::Usecase::Error; end

  class Input < Api::Usecase::Input
    attr_accessor :user

    def initialize(user:)
      @user = user
    end
  end

  def initialize(input:)
    @input = input
  end

  def delete
    if @input.user.destroy
      true
    else
      raise DeleteUserError.new(@input.user.errors.full_messages.join(', '))
    end
  rescue => e
    Rails.logger.error("User deletion failed: #{e.message}")
    raise DeleteUserError.new("User deletion failed: #{e.message}")
  end
end