class Api::TagsController < Api::BaseController
  skip_before_action :verify_authenticity_token
  skip_before_action :set_current_user, only: [:index]

  def index
    usecase = Api::FetchTagsUsecase.new(
      input: Api::FetchTagsUsecase::Input.new
    )
    @output = usecase.fetch

    render json: @output.tags, status: :ok
  rescue => e
    Rails.logger.error("Error: #{e.message}")
    render json: { error: 'Internal server error' }, status: :internal_server_error
  end
end
