# frozen_string_literal: true

class SchedulesController < ApplicationController
  # before_action :authenticate_user!

  def create
    # @schedule = Schedule.new(schedule_params)　良くない書き方
    @schedule = current_user.schedules.build(schedule_params)

    if @schedule.request_timezone == nil && @schedule.request_start_time == "" && @schedule.request_end_time == ""
      flash[:danger]  = "シフトの申請に失敗しました。時間が選択されていません、申請内容を修正してください。"
      return redirect_to pages_requestschedule_path
    end
    if @schedule.request_start_time != "" && @schedule.request_end_time == ""
      flash[:danger]  = "シフトの申請に失敗しました。終了時間が選択されていません、申請内容を修正してください。"
      return redirect_to pages_requestschedule_path
    end
    if @schedule.request_start_time == "" && @schedule.request_end_time != ""
      flash[:danger]  = "シフトの申請に失敗しました。開始時間が選択されていません、申請内容を修正してください。"
      return redirect_to pages_requestschedule_path
    end

    if @schedule.save
      flash[:success] = "シフトの申請ができました。"
      redirect_to pages_requestschedule_path
    else
      flash[:danger]  = "シフトの申請に失敗しました、申請内容を修正してください。"
      redirect_to pages_requestschedule_path
    end
  end

  def destroy
    schedule = Schedule.find_by(id: params[:id])
    schedule.destroy
    flash[:success] = "削除しました"
    redirect_to pages_requestschedule_path
  end

  private

  def schedule_params
    # params.require(:schedule).permit(:request_day, :request_start_time, :request_end_time, :storename, :user_id, request_timezone: [] )
    # params.require(:schedule).permit(:request_day, :request_start_time, :request_end_time, :storename, request_timezone: [] )
    params.require(:schedule).permit(:request_day, :request_start_time, :request_end_time, :store_id, request_timezone: [] )
  end
end
