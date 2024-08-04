class Api::GetUserDetailUsecase < Api::Usecase
  class Input < Api::Usecase::Input
    attr_accessor :id

    def initialize(id:)
      @id = id
    end
  end

  class Output < Api::Usecase::Output
    attr_accessor :user_detail

    def initialize(user_detail:)
      @user_detail = user_detail
    end

    def user
      @user_detail
    end
  end

  def initialize(input:)
    @input = input
  end

  def get
    user = User.find_by!(id: @input.id)

    avatar_data_url = user.avatar_data.present? ? "data:image/png;base64,#{Base64.encode64(user.avatar_data)}" : nil

    user_detail = {
      code: user.code,
      avatar_url: avatar_data_url,
      name: user.name,
      description: user.description
    }

    Output.new(user_detail: user_detail)
  end
end
