require 'uri'

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
    avatar_url_cache = {}
    posts = Post.includes(:tags, :user).order(created_at: :desc).map do |post|
      begin
        user_id = post.user.id
        unless avatar_url_cache.key?(user_id)
          avatar_url = post.user.avatar_url || nil
          if avatar_url
            # URIをエンコードして非ASCII文字を処理
            encoded_url = URI::DEFAULT_PARSER.escape(avatar_url)
            file_key = URI.encode_www_form_component(File.basename(URI.parse(encoded_url).path))
            signed_avatar_url = CloudflareR2Service.new.generate_signed_url(file_key)
            avatar_url_cache[user_id] = signed_avatar_url
          else
            avatar_url_cache[user_id] = nil
          end
        end

        Models::PostCell.new(
          code: post.code,
          avatar_url: avatar_url_cache[user_id],
          name: post.user.name,
          tags: post.tags.map(&:name),
          content: post.content
        )
      rescue => e
        Rails.logger.error("Error generating signed URL for post #{post.id}: #{e.message}")
        nil
      end
    end.compact

    Output.new(posts)
  end
end