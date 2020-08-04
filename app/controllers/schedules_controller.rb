# frozen_string_literal: true

class SchedulesController < ApplicationController
  before_action :authenticate_user!

  # シフト表ページ
  def workschedule
    # エラーハンドリング
    schedule_nil_check = Schedule.first
    if schedule_nil_check == nil
      flash[:error] = "スケジュールのレコードが存在しません。"
      return redirect_to root_path
    end

    @stores = Store.all

    if params[:q] == nil #読み込み時処理
      @users_and_schedules_search = User.ransack(params[:q])
      @users_and_schedules = @users_and_schedules_search.result
    else #検索時処理
      #RansackでUserとScheduleをInnerJoinしたところからシフト申請店舗＆シフト申請月を検索して絞る
      #すべてのUserとScheduleを取得
      # @users_and_schedules_search = User.ransack(params[:q]) #schedulesをInnerJoinしていないのでうまく検索出来ない、下記手法で解決
      @users_and_schedules_search = User.joins(:schedules).ransack(params[:q])

      #勤務時間帯順に並び替え
      @users_and_schedules_search.sorts = 'duty_hours asc' if @users_and_schedules_search.sorts.empty?
      @users_and_schedules = @users_and_schedules_search.result(distinct: true).includes(:schedules) #schedulesをincludesしないと検索がうまくいかない

      #検索対象のレコードがない場合
      if @users_and_schedules.empty?
        flash[:error] = "スケジュールが存在しません。"
        return redirect_to schedules_workschedule_path
      end

      #すべてのUserとScheduleからFirst(1 User hasmany Schedules)を取得
      @user_and_schedules_first = @users_and_schedules.first

      #1 User hasmany SchedulesからSchedulesを取得
      @user_and_schedules_first_schedules = @user_and_schedules_first.schedules

      #1 User hasmany Schedulesから1 Scheduleを取得
      @user_and_schedules_first_schedules_first = @user_and_schedules_first_schedules.first

      #1 Scheduleの日付から月初と月末を抽出
      @beginningday      = @user_and_schedules_first_schedules_first.request_day.beginning_of_month
      @endday            = @user_and_schedules_first_schedules_first.request_day.end_of_month
      #月初から月末までを変数に代入
      @beginningtoendday = @beginningday..@endday

      # シフト時間枠の配列を作成
      @timezones = ["A","B","C","D","E1","E3","E"]
    end
    @check = params[:q] #未検索時チェック
  end

  # シフト申請用ページ
  def requestschedule
    #異常動作回避ロジック（シフト申請先店舗がない場合）
    stores_nil_check = Store.first
    if stores_nil_check == nil
      flash[:error] = "シフトを申請できる店舗が存在しません。"
      return redirect_to root_path
    end

    @requestschedule = Schedule.new #シフト申請用インスタンス変数
    @stores = Store.all #全店舗呼び出し

    if params[:q] == nil #読み込み時処理
      @schedules_search = Schedule.ransack(params[:q])
      @schedules_search.sorts = 'request_day desc' if @schedules_search.sorts.empty?
      @schedules = @schedules_search.result.includes([:user,:store]).where(user_id: current_user.id)
    else #検索時処理
      @schedules_search = Schedule.ransack(params[:q])
      @schedules_search.sorts = 'request_day desc' if @schedules_search.sorts.empty?
      @schedules = @schedules_search.result.includes([:user,:store]).where(user_id: current_user.id)
    end
  end

  # 申請済みシフトの承認ページ（管理者専用）
  def approveschedule
    @users = User.all #全ユーザ取得
    @stores = Store.all #全店舗取得
    @schedules_search = Schedule.ransack(params[:q])
    # @schedules_search.sorts = 'request_day desc' if @schedules_search.sorts.empty?
    @schedules = @schedules_search.result.includes([:user,:store]).order(user_id: 'ASC').order(store_id: 'ASC').order(request_day: 'DESC')
    @check = params[:q]


    # エラーハンドリング
    schedule_nil_check = Schedule.first
    if schedule_nil_check == nil
      flash[:error] = "スケジュールのレコードが存在しません。"
      return redirect_to root_path
    end

    @stores = Store.all

    if params[:q] == nil #読み込み時処理
      @users_and_schedules_search = User.ransack(params[:q])
      @users_and_schedules = @users_and_schedules_search.result
    else #検索時処理
      #RansackでUserとScheduleをInnerJoinしたところからシフト申請店舗＆シフト申請月を検索して絞る
      #すべてのUserとScheduleを取得
      # @users_and_schedules_search = User.ransack(params[:q]) #schedulesをInnerJoinしていないのでうまく検索出来ない、下記手法で解決
      @users_and_schedules_search = User.joins(:schedules).ransack(params[:q])

      #勤務時間帯順に並び替え
      @users_and_schedules_search.sorts = 'duty_hours asc' if @users_and_schedules_search.sorts.empty?
      @users_and_schedules = @users_and_schedules_search.result(distinct: true).includes(:schedules) #schedulesをincludesしないと検索がうまくいかない

      #検索対象のレコードがない場合
      if @users_and_schedules.empty?
        flash[:error] = "スケジュールが存在しません。"
        return redirect_to schedules_workschedule_path
      end

      #すべてのUserとScheduleからFirst(1 User hasmany Schedules)を取得
      @user_and_schedules_first = @users_and_schedules.first

      #1 User hasmany SchedulesからSchedulesを取得
      @user_and_schedules_first_schedules = @user_and_schedules_first.schedules

      #1 User hasmany Schedulesから1 Scheduleを取得
      @user_and_schedules_first_schedules_first = @user_and_schedules_first_schedules.first

      #1 Scheduleの日付から月初と月末を抽出
      @beginningday      = @user_and_schedules_first_schedules_first.request_day.beginning_of_month
      @endday            = @user_and_schedules_first_schedules_first.request_day.end_of_month
      #月初から月末までを変数に代入
      @beginningtoendday = @beginningday..@endday

      # シフト時間枠の配列を作成
      @timezones = ["A","B","C","D","E1","E3","E"]
    end
    @check = params[:q] #未検索時チェック
  end

  #シフト作成
  def create
    @schedule = current_user.schedules.build(schedule_params)

# debugger

    # 申請先店舗には同日シフトの申請はできないようにする
    requested_check = Schedule.find_by(user_id: @schedule.user.id, store_id: @schedule.store.id, request_day: @schedule.request_day)
    unless requested_check == nil
      flash[:error] = "#{@schedule.request_day}は#{@schedule.store.storename}にシフトを申請済みです。申請内容を修正してください。"
      return redirect_to schedules_requestschedule_path
    end

    # 同じ時間枠でに別店舗にシフト申請していないか確認
    # whereで日付検索
    duplicate_check = Schedule.where(user_id: @schedule.user.id, request_day: @schedule.request_day)
    # StringをArrayに変換　不要文字も合わせて削除
    request_timezone_array = @schedule.request_timezone.split(',').map { |m| m.delete('[]"\\\\ ')}
    # 上記でユーザIDと申請日でWhereしたものから、時間枠の重複がないか確認
    request_timezone_array.each do |timezone|
      if timezone == "E1" || timezone == "E3" #Eの付いた時間枠はいずれも21時始まりであることから、E1,E3はEに変換して重複チェックにかかるようにする。
        timezone = "E"
      end
      duplicate_check = duplicate_check.where('request_timezone like ?', "%#{timezone}%")
    end
    # 時間枠の重複があればエラー処理 (whereの結果がemptyならその申請の時間の重複はない→申請してOK)
    unless duplicate_check.empty?
      flash[:error] = 'シフトの申請に失敗しました。別店舗に申請しているシフトと時間の重複があります。申請内容を修正してください。'
      return redirect_to schedules_requestschedule_path
    end

    # @schedule.request_timezone整形、右の文字を削除[" , [ ] ']
    unless @schedule.request_timezone.nil?
      @schedule.request_timezone.gsub!('"', '')
      @schedule.request_timezone.gsub!(',', '')
      @schedule.request_timezone.gsub!('[', '')
      @schedule.request_timezone.gsub!(']', '')
      @schedule.request_timezone.gsub!(' ', '')
    end

    if @schedule.request_timezone.nil? && @schedule.request_start_time == '' && @schedule.request_end_time == ''
      flash[:error] = 'シフトの申請に失敗しました。時間が選択されていません、申請内容を修正してください。'
      return redirect_to schedules_requestschedule_path
    end
    if @schedule.request_start_time != '' && @schedule.request_end_time == ''
      flash[:error] = 'シフトの申請に失敗しました。終了時間が選択されていません、申請内容を修正してください。'
      return redirect_to schedules_requestschedule_path
    end
    if @schedule.request_start_time == '' && @schedule.request_end_time != ''
      flash[:error] = 'シフトの申請に失敗しました。開始時間が選択されていません、申請内容を修正してください。'
      return redirect_to schedules_requestschedule_path
    end

    if @schedule.save

      # relationship = Relationship.new(:user_id: @schedule.user.id, :store_id: @schedule.store.id)
      # relationship.save
      # @schedule.update_attribute(:approved, true)

      flash[:success] = 'シフトの申請ができました。'
      redirect_to schedules_requestschedule_path
    else
      flash[:error] = 'シフトの申請に失敗しました、申請内容を修正してください。'
      redirect_to schedules_requestschedule_path
    end
  end

  # シフト承認用UPDATEロジック （管理者専用）
  def update
    @schedule = Schedule.find_by(id: params[:id])

    if @schedule.approved == false
      if @schedule.update_attribute(:approved, true)
        # flash[:success] = 'シフトを承認しました。'
        # redirect_to schedules_approveschedule_path
      else
        # flash[:error]  = '承認に失敗しました、サイト管理者に問い合わせてください。'
        # redirect_to schedules_approveschedule_path
      end
    else
      if @schedule.update_attribute(:approved, false)
        # flash[:success] = '承認を解除しました。'
        # redirect_to schedules_approveschedule_path
      else
        # flash[:error]  = '承認解除に失敗しました、サイト管理者に問い合わせてください。'
        # redirect_to schedules_approveschedule_path
      end
    end
  end

  # シフト削除
  def destroy
    @schedule = Schedule.find_by(id: params[:id])
    @schedule.destroy
    # flash[:success] = 'シフトを削除しました。'
    # flash[:success] = '削除しました'
    # redirect_to schedules_requestschedule_path
    # render schedules_requestschedule_path
  end

  private

  # Strong parameterチェック
  def schedule_params
    # params.require(:schedule).permit(:request_day, :request_start_time, :request_end_time, :storename, :user_id, request_timezone: [] )
    # params.require(:schedule).permit(:request_day, :request_start_time, :request_end_time, :storename, request_timezone: [] )
    params.require(:schedule).permit(:request_day, :request_start_time, :request_end_time, :store_id, request_timezone: [])
  end

  # def search_params
  #   # params.require(:q).permit(:request_day, :request_start_time, :request_end_time, :store_id, request_timezone: [])
  #   params.require(:q).permit!
  # end
end
