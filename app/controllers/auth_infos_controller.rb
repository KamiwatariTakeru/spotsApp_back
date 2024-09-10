class AuthInfosController < ApplicationController
  before_action :set_auth_info, only: %i[ show update destroy ]

  # GET /auth_infos
  def index
    @auth_infos = AuthInfo.all

    render json: @auth_infos
  end

  # GET /auth_infos/1
  def show
    render json: @auth_info
  end

  # POST /auth_infos
  def create
    @auth_info = AuthInfo.new(auth_info_params)

    if @auth_info.save
      render json: @auth_info, status: :created, location: @auth_info
    else
      render json: @auth_info.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /auth_infos/1
  def update
    if @auth_info.update(auth_info_params)
      render json: @auth_info
    else
      render json: @auth_info.errors, status: :unprocessable_entity
    end
  end

  # DELETE /auth_infos/1
  def destroy
    @auth_info.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_auth_info
      @auth_info = AuthInfo.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def auth_info_params
      params.require(:auth_info).permit(:provider, :user_id)
    end
end
