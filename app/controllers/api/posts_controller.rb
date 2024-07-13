class Api::PostsController < Api::BaseController
  skip_before_action :verify_authenticity_token

  def create
    input = Api::CreatePostUsecase::Input.new(content: params[:content], tags: params[:tags], user_id: @current_user.id)
    usecase = Api::CreatePostUsecase.new(input: input)
    
    if usecase.create
      @output = usecase.output
      render 'api/posts/create', status: :created, formats: [:json]
    else
      render json: { error: 'Invalid input' }, status: :unprocessable_entity
    end
  rescue => e
    Rails.logger.error("Error: #{e.message}")
    render json: { error: 'Internal server error' }, status: :internal_server_error
  end
end
