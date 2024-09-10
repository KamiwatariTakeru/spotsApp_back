class EvaluationsController < ApplicationController
  def getEvaluationRecord
    evaluation = Evaluation.find_by(user_id: params[:user_id], spot_id: params[:spot_id])

    # ユーザーがその投稿を初めて評価する場合（新規登録）
    if evaluation.nil?
      evaluation = Evaluation.new(evaluation_params)
      # 新規登録の場合は"starsAmount"は"spots.evaluate"でレコードに登録する
      evaluation.starsAmount = 0

      if evaluation.save
        redirect_to evaluate_spot_path(user_id: evaluation.user_id, id: params[:spot_id], stars_amount: params[:starsAmount])
      else
        render json: evaluation.errors, status: :internal_server_error
      end
    # すでにユーザーがその投稿を評価していた場合（更新）
    else
        redirect_to evaluate_spot_path(user_id: evaluation.user_id, id: params[:spot_id], stars_amount: params[:starsAmount])
    end
  end

  private
  def evaluation_params
    params.require(:evaluation).permit(:user_id, :spot_id, :starsAmount)
  end
end
