# frozen_string_literal: true

class StoresController < ApplicationController
  # before_action :authenticate_user!

  def create
    @store = Store.new(store_params)

    if @store.storename == nil or @store.storename == ""
      flash[:danger]  = "申請内容を修正してください。"
      return redirect_to pages_addstores_path
    end

    if @store.save
      flash[:success] = "店舗を追加しました。"
      redirect_to pages_addstores_path
    else
      flash[:danger]  = "店舗追加に失敗しました、申請内容を修正してください。"
      redirect_to pages_addstores_path
    end
  end

  # def destroy
  #   schedule = Schedule.find_by(id: params[:id])
  #   schedule.destroy
  #   flash[:success] = "削除しました"
  #   redirect_to pages_requestschedule_path
  # end

  private

  def store_params
    params.require(:store).permit(:storename)
  end
end
