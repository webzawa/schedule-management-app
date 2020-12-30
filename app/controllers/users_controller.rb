class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :admin_user, :only => %i[adminsettings update update_confirmed_at destroy]

  # 管理者用設定
  def adminsettings
    @store  = Store.new
    @stores = Store.all.order(:storename => 'ASC')
    @schedule_checkbox  = ScheduleCheckbox.new
    @schedule_checkboxes = ScheduleCheckbox.all.order(:id => 'ASC')
    @users_search = User.ransack(params[:q])
    @users = @users_search.result.order(:created_at => 'DESC').page(params[:page])
    @check = params[:q]
  end

  # 管理者用設定
  def update
    @user = User.find_by(:id => params[:id])
    @msg = if @user.admin == false
             if @user.update_attribute(:admin, true)
               @updated = true
               "ユーザ「#{@user.username}」に管理者権限を付与しました。"
             else
               "ユーザ「#{@user.username}」の管理者権限の付与に失敗しました、サイト管理者に問い合わせてください。"
             end
           else
             if @user.update_attribute(:admin, false)
               @updated = true
               "ユーザ「#{@user.username}」の管理者権限を解除しました。"
             else
               "ユーザ「#{@user.username}」の管理者権限の解除に失敗しました、サイト管理者に問い合わせてください。"
             end
           end
  end

  # 管理者用設定
  def update_confirmed_at
    @user = User.find_by(:id => params[:id])
    @msg = if @user.confirmed_at.blank?
             if @user.update_attribute(:confirmed_at, Time.now)
               @updated = true
               "ユーザ「#{@user.username}」のログインを承認しました。"
             else
               "ユーザ「#{@user.username}」のログイン承認に失敗しました、サイト管理者に問い合わせてください。"
             end
           else
             if @user.update_attribute(:confirmed_at, nil)
               @updated = true
               "ユーザ「#{@user.username}」のログインを非承認にしました。"
             else
               "ユーザ「#{@user.username}」のログイン非承認に失敗しました、サイト管理者に問い合わせてください。"
             end
           end
  end

  # 管理者用設定
  def destroy
    @user = User.find_by(:id => params[:id])
    @msg = if @user.destroy
             @deleted = true
             "ユーザ「#{@user.username}」を削除しました。"
           else
             "ユーザ「#{@user.username}」の削除に失敗しました。"
           end
  end

  def update_to_comment
    @user = User.find_by(:id => params[:id])
    if @user.update(update_to_comment_params)
      flash[:success] = 'その他要望を更新しました。'
      redirect_to schedules_requestschedule_path
    else
      flash[:error] = 'その他要望の更新に失敗しました。'
      redirect_to schedules_requestschedule_path
    end
  end

  private

  def update_to_comment_params
    params.require(:user).permit(
      :comment
    )
  end

end
