class Api::PostsController < Api::BaseController
  skip_before_action :verify_authenticity_token
  skip_before_action :set_current_user, only: [:index, :show, :generate_signed_url]

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

    render json: @output.post_detail, status: :ok
  rescue ActiveRecord::RecordNotFound => e
    Rails.logger.error("Error: #{e.message}")
    render json: { error: 'Post not found' }, status: :not_found
  rescue => e
    Rails.logger.error("Error: #{e.message}")
    render json: { error: 'Internal server error' }, status: :internal_server_error
  end

  def generate_signed_url
    file_key = params[:file_key] # ファイルキーをリクエストパラメータから取得
    expires_in = params[:expires_in] || 3600 # 有効期限（デフォルト1時間）

    service = CloudflareR2Service.new
    signed_url = service.generate_signed_url(file_key, expires_in.to_i)

    render json: { signed_url: signed_url }, status: :ok
  rescue => e
    Rails.logger.error("Error: #{e.message}")
    render json: { error: 'Failed to generate signed URL' }, status: :internal_server_error
  end
end
