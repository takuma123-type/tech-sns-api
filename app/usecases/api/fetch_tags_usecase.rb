class Api::FetchTagsUsecase < Api::Usecase
  class Input < Api::Usecase::Input
  end

  class Output < Api::Usecase::Output
    attr_accessor :tags

    def initialize(tags)
      @tags = tags
    end
  end

  def fetch
    tags = Tag.order(created_at: :desc).map do |tag|
      Models::TagCell.new(name: tag.name)
    end

    Output.new(tags)
  end
end