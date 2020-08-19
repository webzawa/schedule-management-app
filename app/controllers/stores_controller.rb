# frozen_string_literal: true

class StoresController < ApplicationController
  before_action :authenticate_user!
  before_action :admin_user

  # 管理者専用コントローラ

  # 店舗追加
  def create
    @store = Store.new(store_params)

    dupcheck = Store.find_by(:storename => @store.storename)
    unless dupcheck.nil?
      flash[:error] = '店舗の登録に失敗しました。既存の店舗名は登録できません、申請内容を修正してください。'
      return redirect_to users_adminsettings_path
    end

    if @store.save
      flash[:success] = '店舗を追加しました。'
      redirect_to users_adminsettings_path
    else
      flash[:error] = '店舗追加に失敗しました。'
      redirect_to users_adminsettings_path
    end
  end

  def destroy
    store = Store.find_by(:id => params[:id])
    store.destroy
    flash[:success] = '削除しました'
    redirect_to users_adminsettings_path
  end

  private

  def store_params
    params.require(:store).permit(:storename)
  end
end
