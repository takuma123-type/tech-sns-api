class Api::UpdateProfileUsecase < Api::Usecase
  class UpdateProfileError < Api::Usecase::Error; end

  class Input < Api::Usecase::Input
    attr_accessor :user, :name, :avatar, :description

    def initialize(user:, name:, avatar:, description:)
      @user = user
      @name = name
      @avatar = avatar
      @description = description
    end
  end

  class Output < Api::Usecase::Output
    attr_accessor :token

    def initialize(token:)
      @token = token
    end
  end

  def update
    begin
      avatar_data = input.avatar.read if input.avatar.present?

      user_params = {
        name: input.name,
        avatar_data: avatar_data || input.user.avatar_data,
        description: input.description
      }

      if input.user.update(user_params)
        token = input.user.generate_jwt # トークンを生成
        Output.new(token: token)
      else
        raise UpdateProfileError.new(input.user.errors.full_messages.join(', '))
      end
    rescue => e
      Rails.logger.error("Profile update failed: #{e.message}")
      raise UpdateProfileError.new("Profile update failed: #{e.message}")
    end
  end
end
