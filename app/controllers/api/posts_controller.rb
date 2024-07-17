class Api::PostsController < Api::BaseController
  skip_before_action :verify_authenticity_token
  skip_before_action :set_current_user, only: [:index, :show]

  def index
    usecase = Api::FetchPostsUsecase.new(
      input: Api::FetchPostsUsecase::Input.new
    )
    @output = usecase.fetch

    render json: @output.posts, status: :ok
  rescue => e
    Rails.logger.error("Error: #{e.message}")
    render json: { error: 'Internal server error' }, status: :internal_server_error
  end

  def create
    input = Api::CreatePostUsecase::Input.new(
      content: params[:content], tags: params[:tags], user_id: @current_user.id)
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

  def show
    usecase = Api::GetPostDetailUsecase.new(
      input: Api::GetPostDetailUsecase::Input.new(code: params[:code])
    )
    @output = usecase.get
    render json: @output.post, status: :ok
  rescue => e
    Rails.logger.error("Error: #{e.message}")
    render json: { error: 'Internal server error' }, status: :internal_server_error
  end
end
