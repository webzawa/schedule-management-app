class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :admin_user

  # 管理者用設定
  def adminsettings
    @store  = Store.new
    @stores = Store.all.order(:storename => 'ASC')
    @users_search = User.ransack(params[:q])
    @users = @users_search.result.order(:admin => 'DESC').order(:duty_hours => 'ASC').order(:username => 'ASC')
    @check = params[:q]
  end

  def update
    user = User.find_by(:id => params[:id])
    if user.admin == false
      if user.update_attribute(:admin, true)
        flash[:success] = "ユーザ「#{user.username}」に管理者権限を付与しました。"
        redirect_to users_adminsettings_path
      else
        flash[:error] = "ユーザ「#{user.username}」の管理者権限の付与に失敗しました、サイト管理者に問い合わせてください。"
        redirect_to users_adminsettings_path
      end
    else
      if user.update_attribute(:admin, false)
        flash[:success] = "ユーザ「#{user.username}」の管理者権限を削除しました。"
        redirect_to users_adminsettings_path
      else
        flash[:error] = "ユーザ「#{user.username}」の管理者権限の削除に失敗しました、サイト管理者に問い合わせてください。"
        redirect_to users_adminsettings_path
      end
    end
  end

  def update_confirmed_at
    user = User.find_by(:id => params[:id])
    if user.confirmed_at.blank?
      if user.update_attribute(:confirmed_at, Time.now)
        flash[:success] = "ユーザ「#{user.username}」のログインを承認しました。"
        redirect_to users_adminsettings_path
      else
        flash[:error] = "ユーザ「#{user.username}」のログイン承認に失敗しました、サイト管理者に問い合わせてください。"
        redirect_to users_adminsettings_path
      end
    else
      if user.update_attribute(:confirmed_at, nil)
        flash[:success] = "ユーザ「#{user.username}」のログインを非承認にしました。"
        redirect_to users_adminsettings_path
      else
        flash[:error] = "ユーザ「#{user.username}」のログイン非承認に失敗しました、サイト管理者に問い合わせてください。"
        redirect_to users_adminsettings_path
      end
    end
  end

  def destroy
    user = User.find_by(:id => params[:id])
    if user.destroy
      flash[:success] = "ユーザ「#{user.username}」を削除しました。"
      redirect_to users_adminsettings_path
    else
      flash[:error] = "ユーザ「#{user.username}」の削除に失敗しました。"
      redirect_to users_adminsettings_path
    end
  end

end
