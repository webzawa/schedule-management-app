# frozen_string_literal: true

class StoresController < ApplicationController
  before_action :authenticate_user!

  def create
    @store = Store.new(store_params)

    if @store.storename == nil or @store.storename == ""
      flash[:error]  = "申請内容を修正してください。"
      return redirect_to users_adminsettings_path
    end

    if @store.save
      flash[:success] = "店舗を追加しました。"
      redirect_to users_adminsettings_path
    else
      flash[:error]  = "店舗追加に失敗しました、申請内容を修正してください。"
      redirect_to users_adminsettings_path
    end
  end

  def destroy
    store = Store.find_by(id: params[:id])
    store.destroy
    flash[:success] = "削除しました"
    redirect_to users_adminsettings_path
  end

  private

  def store_params
    params.require(:store).permit(:storename)
  end
end
