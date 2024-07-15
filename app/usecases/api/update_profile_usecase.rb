class Api::UpdateProfileUsecase < Api::Usecase
  class UpdateProfileError < Api::Usecase::Error; end

  class Input < Api::Usecase::Input
    attr_accessor :user, :name, :avatar, :description
  end

  class Output < Api::Usecase::Output
    attr_accessor :token

    def initialize(token)
      @token = token
    end
  end

  def update
    begin
      avatar_url = upload_avatar if input.avatar.present?

      # ここで input.user.update が正しい形式の引数を受け取るようにする
      user_params = { name: input.name, avatar_url: avatar_url || input.user.avatar_url, description: input.description }
      
      if input.user.update(user_params)
        token = input.user.generate_jwt # トークンを生成
        Output.new(token)
      else
        raise UpdateProfileError.new(input.user.errors.full_messages.join(', '))
      end
    rescue => e
      Rails.logger.error("Profile update failed: #{e.message}")
      raise UpdateProfileError.new("Profile update failed: #{e.message}")
    end
  end

  private

  def upload_avatar
    service = CloudflareR2Service.new
    service.upload(input.avatar)
  end
end
