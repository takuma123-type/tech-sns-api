class Api::UpdateProfileUsecase < Api::Usecase
  class UpdateProfileError < Api::Usecase::Error; end

  class Input < Api::Usecase::Input
    attr_accessor :user, :name, :avatar_url, :description
  end

  class Output < Api::Usecase::Output; end

  def update
    if input.user.update(name: input.name, avatar_url: input.avatar_url, description: input.description)
      Output.new
    else
      raise UpdateProfileError.new(input.user.errors.full_messages.join(', '))
    end
  end
end