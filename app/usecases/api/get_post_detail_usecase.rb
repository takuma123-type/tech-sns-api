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
  end

  def initialize(input:)
    @input = input
  end

  def get
    post = Post.includes(:tags, :user).find_by!(code: @input.code)

    post_detail = Models::PostCell.new(
      avatar_url: post.user.avatar_url,
      name: post.user.name,
      tags: post.tags.map(&:name),
      content: post.content
    )

    Output.new(post_detail: post_detail)
  end
end
