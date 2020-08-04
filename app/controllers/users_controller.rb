class UsersController < ApplicationController

  def adminsettings
    @store  = Store.new
    @stores = Store.all.order(storename: 'ASC')
    @users_search = User.ransack(params[:q])
    @users = @users_search.result.order(admin: 'DESC').order(duty_hours: 'ASC').order(username: 'ASC')
    @check = params[:q]
  end

  def update
    unless current_user.admin == true
      flash[:error] = '管理者権限の付与に失敗しました、この操作は管理者のみに許可されています。'
      return redirect_to users_adminsettings_path
    end

    user = User.find_by(id: params[:id])
    if user.admin == false
      if user.update_attribute(:admin, true)
        flash[:success] = '指定のユーザに管理者権限を付与しました。'
        redirect_to users_adminsettings_path
      else
        flash[:error]  = '管理者権限の付与に失敗しました、サイト管理者に問い合わせてください。'
        redirect_to users_adminsettings_path
      end
    else
      if user.update_attribute(:admin, false)
        flash[:success] = '管理者権限を削除しました。'
        redirect_to users_adminsettings_path
      else
        flash[:error]  = '管理者権限の削除に失敗しました、サイト管理者に問い合わせてください。'
        redirect_to users_adminsettings_path
      end
    end
  end

end
