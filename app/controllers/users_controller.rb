class UsersController < ApplicationController
  before_action :set_user, only: [:update, :destroy]

  # GET /users
  def index
    @users = User.all
    render json: @users
  end

  # users/get_current_user/:uid
  def getCurrentUser
    authInfo = AuthInfo.find_by(id: params[:uid])

    unless authInfo
      return render json: { error: "認証情報が見つかりませんでした" }, status: :bad_request
    end

    currentUser = User.find_by(id: authInfo.user_id)

    unless currentUser
      return render json: { error: "ユーザーが見つかりませんでした" }, status: :bad_request
    end

    render json: currentUser

  rescue StandardError => e
    render json: { error: e.message }, status: :internal_server_error
  end

  # POST /users
  def create
    # 条件に該当するデータがあればそれを返す。なければ新規作成
    authInfo = AuthInfo.find_by(id: params[:uid])

    # 認証情報が存在した場合は、それに紐付くユーザーを検索
    if authInfo
      user = User.find(authInfo.user_id)

    # 認証情報が存在しなかった場合は、それに紐付くユーザーも存在しないため両方作成
    else
      # UUID生成
      uuid = SecureRandom.uuid
      User.create(id: uuid, name: params[:name], email: params[:email])
      AuthInfo.create(id: params[:uid], provider: params[:provider], user_id: uuid)
    end

    # ここで念の為にユーザーと認証情報が存在するかチェック
    if user and authInfo
      head :ok
    else
      # 500エラー（内部エラー）
      return render json: { error: "ユーザーまたは認証情報が存在しません" }, status: :internal_server_error
    end
  # それ以外の例外
  rescue StandardError => e
    # 500エラー（内部エラー）
    render json: { error: e.message }, status: :internal_server_error
  end

  # PATCH/PUT /users/1
  def update
    if @user.update(user_params)
      render json: @user
    else
      render json: @user.errors, status: :internal_server_error
    end
  end

  # DELETE /users/1
  def destroy
    @user.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
      unless user
        return render json: { error: "ユーザーが見つかりませんでした" }, status: :bad_request
      end
    end

    # Only allow a trusted parameter "white list" through.
    def user_params
      params.require(:user).permit(:email, :name)
    end
end
