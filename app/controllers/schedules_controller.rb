# frozen_string_literal: true

class SchedulesController < ApplicationController
  # before_action :authenticate_user!

  def nextmonth
  #   @beginningday      = Date.today.beginning_of_month
  #   @endday            = Date.today.end_of_month
  #   @beginningday      = @beginningday >> 1
  #   @endday            = @endday >> 1

  #   @beginningtoendday = @beginningday..@endday
  #   redirect_to schedules_workschedule_path

  end

  def workschedule
    # @users = User.all #RerationshopModelから取得するよう変更予定
    @users = Schedule.select(:user_id).distinct
    @stores = Store.all

    # @beginningday      = Date.today.beginning_of_month
    # @endday            = Date.today.end_of_month
    # @beginningtoendday = @beginningday..@endday

    #↓Ransackで店舗＆月を検索して絞る
    # @search = Schedule.ransack(params[:q])
    @schedules_search = Schedule.ransack(params[:q])
    @schedules = @schedules_search.result.order(request_day: 'ASC')

    @check = params[:q]

    @schedule = @schedules.first
    # @users = User.find_by(store_id: @store.store.id)
    
    if @schedule == nil
      flash[:danger] = '指定された店舗、または指定された年月のシフトが存在しません。'
      return redirect_to schedules_workschedule_path
    else
      # 指定店舗が存在する　スケジュールがある
      @beginningday      = @schedule.request_day.beginning_of_month
      @endday            = @schedule.request_day.end_of_month
      @beginningtoendday = @beginningday..@endday

      # @users = Schedule.select(:user_id).distinct
      @users = @schedules.select(:user_id).distinct
      
      # @schedule_has_users = Schedule.where(store_id: @schedule.store.id)
      # @schedule_has_users = @schedule_has_users.include(:users)
      # @users = @schedule.user
      # Relationshipモデルを作成する（USER,STORE関連付け用） exm: @users = Relationship.where(store_id: @schedule.store.id)
    end

  end

  def requestschedule
    @requestschedule = Schedule.new
    # @stores = Store.all
    @schedules = Schedule.all.order(user_id: 'ASC').order(request_day: 'DESC')
    # @schedules = Schedule.find_by(user_id: current_user.id)
    @user = User.find_by(id: current_user.id)
    # @user = User.find_by(id: user_id)
    # @store = Store.find_by(id: @schedule.store_id)
  end

  def approveschedule
    # @user = User.find_by(id: current_user.id)
    # @stores = Store.all
    @schedules = Schedule.all.order(user_id: 'ASC').order(request_day: 'DESC')
    @approveschedules = Schedule.new
  end

  def addstores
    @store  = Store.new
    @stores = Store.all.order(id: 'ASC')
  end

  def create
    # @schedule = Schedule.new(schedule_params)　良くない書き方
    @schedule = current_user.schedules.build(schedule_params)

    dupcheck = Schedule.find_by(user_id: @schedule.user.id, store_id: @schedule.store.id, request_day: @schedule.request_day)
    unless dupcheck == nil
      flash[:danger] = 'シフトの申請に失敗しました。指定日のシフトは申請済みです、申請内容を修正してください。'
      return redirect_to schedules_requestschedule_path
    end

    if @schedule.request_timezone.nil? && @schedule.request_start_time == '' && @schedule.request_end_time == ''
      flash[:danger] = 'シフトの申請に失敗しました。時間が選択されていません、申請内容を修正してください。'
      return redirect_to schedules_requestschedule_path
    end
    if @schedule.request_start_time != '' && @schedule.request_end_time == ''
      flash[:danger] = 'シフトの申請に失敗しました。終了時間が選択されていません、申請内容を修正してください。'
      return redirect_to schedules_requestschedule_path
    end
    if @schedule.request_start_time == '' && @schedule.request_end_time != ''
      flash[:danger] = 'シフトの申請に失敗しました。開始時間が選択されていません、申請内容を修正してください。'
      return redirect_to schedules_requestschedule_path
    end

    # @schedule.request_timezone.delete(',[]')
    unless @schedule.request_timezone.nil?
      @schedule.request_timezone.gsub!('"', '')
      @schedule.request_timezone.gsub!(',', '')
      @schedule.request_timezone.gsub!('[', '')
      @schedule.request_timezone.gsub!(']', '')
      @schedule.request_timezone.gsub!(' ', '')
    end

    if @schedule.save

      # relationship = Relationship.new(:user_id: @schedule.user.id, :store_id: @schedule.store.id)
      # relationship.save
      # @schedule.update_attribute(:approved, true)

      flash[:success] = 'シフトの申請ができました。'
      redirect_to schedules_requestschedule_path
    else
      flash[:danger] = 'シフトの申請に失敗しました、申請内容を修正してください。'
      redirect_to schedules_requestschedule_path
    end
  end

  def update
    @schedule = Schedule.find_by(id: params[:id])

    if @schedule.approved == false
      if @schedule.update_attribute(:approved, true)
        # flash[:success] = 'シフトを承認しました。'
        # redirect_to schedules_approveschedule_path
      else
        # flash[:danger]  = '承認に失敗しました、サイト管理者に問い合わせてください。'
        # redirect_to schedules_approveschedule_path
      end
    else
      if @schedule.update_attribute(:approved, false)
        # flash[:success] = '承認を解除しました。'
        # redirect_to schedules_approveschedule_path
      else
        # flash[:danger]  = '承認解除に失敗しました、サイト管理者に問い合わせてください。'
        # redirect_to schedules_approveschedule_path
      end
    end
  end

  def destroy
    @schedule = Schedule.find_by(id: params[:id])
    @schedule.destroy
    # flash[:success] = '削除しました'
    # redirect_to schedules_requestschedule_path
  end

  private

  def schedule_params
    # params.require(:schedule).permit(:request_day, :request_start_time, :request_end_time, :storename, :user_id, request_timezone: [] )
    # params.require(:schedule).permit(:request_day, :request_start_time, :request_end_time, :storename, request_timezone: [] )
    params.require(:schedule).permit(:request_day, :request_start_time, :request_end_time, :store_id, request_timezone: [])
  end

  # def search_params
    # params.require(:q).permit(:request_day, :request_start_time, :request_end_time, :store_id, request_timezone: [])
  # end
end
