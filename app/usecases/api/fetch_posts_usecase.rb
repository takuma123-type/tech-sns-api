class Api::FetchPostsUsecase < Api::Usecase
  class Input < Api::Usecase::Input
  end

  class Output < Api::Usecase::Output
    attr_accessor :posts

    def initialize(posts)
      @posts = posts
    end
  end

  def fetch
    posts = Post.includes(:tags, :user).all.map do |post|
      Models::PostCell.new(
        code: post.code,
        avatar_url: post.user.avatar_url,
        name: post.user.name,
        tags: post.tags.map(&:name),
        content: post.content
      )
    end

    Output.new(posts)
  end
end
