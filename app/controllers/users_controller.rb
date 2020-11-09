class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :admin_user

  # 管理者用設定
  def adminsettings
    @store  = Store.new
    @stores = Store.all.order(:storename => 'ASC')
    @schedule_checkbox  = ScheduleCheckbox.new
    @schedule_checkboxes = ScheduleCheckbox.all.order(:name_for_checkbox => 'ASC')
    @users_search = User.ransack(params[:q])
    @users = @users_search.result.order(:admin => 'DESC').order(:duty_hours => 'ASC').order(:username => 'ASC')
    @check = params[:q]
  end

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
               "ユーザ「#{@user.username}」の管理者権限を削除しました。"
             else
               "ユーザ「#{@user.username}」の管理者権限の削除に失敗しました、サイト管理者に問い合わせてください。"
             end
           end
  end

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

  def destroy
    @user = User.find_by(:id => params[:id])

    @msg = if @user.destroy
             @deleted = true
             "ユーザ「#{@user.username}」を削除しました。"
           else
             "ユーザ「#{@user.username}」の削除に失敗しました。"
           end
  end

end
