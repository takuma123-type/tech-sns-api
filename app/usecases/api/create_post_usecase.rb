class Api::CreatePostUsecase < Api::Usecase
  class Input < Api::Usecase::Input
    attr_accessor :content, :tags, :user_id
  end

  class Output < Api::Usecase::Output
    attr_accessor :post
  end

  attr_reader :output

  def create
    unless valid_input?
      Rails.logger.warn(self.class) { "input の内容が不十分です。content: #{input.content}" }
      raise InvalidParameterError.new
    end

    if input.tags.present? && input.tags.size > 3
      Rails.logger.warn(self.class) { "タグの数が多すぎます。tags: #{input.tags.join(", ")}" }
      raise InvalidParameterError.new('タグは最大3つまでです')
    end

    begin
      post = Post.create!(content: input.content, user_id: input.user_id)
      input.tags.each do |tag_name|
        tag = Tag.find_or_create_by!(name: tag_name)
        post.tags << tag
      end if input.tags.present?
      @output = Output.new(post: post)
      true
    rescue ActiveRecord::RecordInvalid => e
      Rails.logger.warn(self.class) { "ポストの保存に失敗しました。errors: #{e.record.errors.full_messages.join(", ")}" }
      raise InvalidParameterError.new
    rescue => e
      Rails.logger.error("Unexpected error: #{e.message}")
      raise
    end
  end

  private

  def valid_input?
    !input.content.blank? && !input.user_id.nil?
  end
end
