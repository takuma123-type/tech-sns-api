class Api::GetPostDetailUsecase < Api::Usecase
  class Input < Api::Usecase::Input
    attr_accessor :code

    def initialize(code:)
      @code = code
    end
  end

  class Output < Api::Usecase::Output
    attr_accessor :post_detail

    def initialize(post_detail:)
      @post_detail = post_detail
    end

    def post
      @post_detail
    end
  end

  def initialize(input:)
    @input = input
  end

  def get
    post = Post.includes(:tags, :user).find_by!(code: @input.code)

    avatar_data_url = post.user.avatar_data.present? ? "data:image/png;base64,#{Base64.encode64(post.user.avatar_data)}" : nil

    post_detail = Models::PostCell.new(
      code: post.code,
      avatar_url: avatar_data_url,
      name: post.user.name,
      tags: post.tags.map(&:name),
      content: post.content
    )

    Output.new(post_detail: post_detail)
  end
end
