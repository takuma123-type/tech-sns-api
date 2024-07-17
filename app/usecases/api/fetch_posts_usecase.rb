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
    posts = Post.includes(:tags, :user).order(created_at: :desc).map do |post|
      avatar_data_url = post.user.avatar_data.present? ? "data:image/png;base64,#{Base64.encode64(post.user.avatar_data)}" : nil

      Models::PostCell.new(
        code: post.code,
        avatar_url: avatar_data_url,
        name: post.user.name,
        tags: post.tags.map(&:name),
        content: post.content
      )
    end

    Output.new(posts)
  end
end
