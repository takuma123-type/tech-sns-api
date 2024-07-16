require 'uri'

class Api::FetchPostsUsecase < Api::Usecase
  class Input < Api::Usecase::Input
  end

  class Output < Api::Usecase::Output
    attr_accessor :posts, :avatar_urls

    def initialize(posts, avatar_urls)
      @posts = posts
      @avatar_urls = avatar_urls
    end
  end

  def fetch
    avatar_url_cache = {}
    avatar_urls = {}
    posts = Post.includes(:tags, :user).order(created_at: :desc).map do |post|
      begin
        user_id = post.user.id
        unless avatar_url_cache.key?(user_id)
          avatar_url = post.user.avatar_url || nil
          if avatar_url
            # URIをエンコードして非ASCII文字を処理
            decoded_url = URI.decode_www_form_component(avatar_url)
            encoded_url = URI.encode_www_form_component(decoded_url)
            file_key = File.basename(URI.parse(encoded_url).path)
            signed_avatar_url = CloudflareR2Service.new.generate_signed_url(file_key)
            avatar_url_cache[user_id] = signed_avatar_url
            avatar_urls[post.id] = signed_avatar_url
            Rails.logger.debug("Generated signed URL: #{signed_avatar_url}")
          else
            avatar_url_cache[user_id] = nil
            avatar_urls[post.id] = nil
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
  
    Output.new(posts, avatar_urls)
  end
end