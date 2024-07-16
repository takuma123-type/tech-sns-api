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
    service = CloudflareR2Service.new

    posts = Post.includes(:tags, :user).order(created_at: :desc).all.map do |post|
      avatar_url = post.user.avatar_url ? service.generate_signed_url(post.user.avatar_url.split('/').last) : nil
      Models::PostCell.new(
        code: post.code,
        avatar_url: avatar_url,
        name: post.user.name,
        tags: post.tags.map(&:name),
        content: post.content
      )
    end

    Output.new(posts)
  end
end