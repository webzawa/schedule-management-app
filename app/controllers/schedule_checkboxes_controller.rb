class ScheduleCheckboxesController < ApplicationController
  before_action :authenticate_user!
  before_action :admin_user

  # 管理者専用コントローラ

  # シフト項目追加
  def create
    @schedule_checkbox = ScheduleCheckbox.new(schedule_checkbox_params)

    dupcheck = ScheduleCheckbox.find_by(:name_for_checkbox => @schedule_checkbox.name_for_checkbox)
    unless dupcheck.nil?
      flash[:error] = '項目の追加に失敗しました。既存の項目名は登録できません。'
      return redirect_to users_adminsettings_path
    end

    if @schedule_checkbox.save
      flash[:success] = '項目を追加しました。'
      redirect_to users_adminsettings_path
    else
      flash[:error] = '項目追加に失敗しました。'
      redirect_to users_adminsettings_path
    end
  end

  def destroy
    schedule_checkbox = ScheduleCheckbox.find_by(:id => params[:id])
    schedule_checkbox.destroy
    flash[:success] = '削除しました'
    redirect_to users_adminsettings_path
  end

  private

  def schedule_checkbox_params
    params.require(:schedule_checkbox).permit(:name_for_checkbox)
  end
end
