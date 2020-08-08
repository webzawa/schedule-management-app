# frozen_string_literal: true

class SchedulesController < ApplicationController
  before_action :authenticate_user!

  # シフト表ページ
  def workschedule
    render_schedule_calender('workschedule')
  end

  # 申請済みシフトの承認ページ（管理者専用）
  def approveschedule
    render_schedule_calender('approveschedule')
  end

  # シフト申請用ページ
  def requestschedule
    # 異常動作回避ロジック（シフト申請先店舗がない場合）
    stores_nil_check = Store.first
    if stores_nil_check.nil?
      flash[:error] = 'シフトを申請できる店舗が存在しません。'
      return redirect_to root_path
    end

    @requestschedule = Schedule.new # シフト申請用インスタンス変数
    timezones
    @stores = Store.all # 全店舗呼び出し

    if params[:q].nil? # 読み込み時処理
      @schedules_search = Schedule.ransack(params[:q])
      @schedules_search.sorts = 'request_day desc' if @schedules_search.sorts.empty?
      @schedules = @schedules_search.result.includes(%i[user store]).where(:user_id => current_user.id)
    else # 検索時処理
      @schedules_search = Schedule.ransack(params[:q])
      @schedules_search.sorts = 'request_day desc' if @schedules_search.sorts.empty?
      @schedules = @schedules_search.result.includes(%i[user store]).where(:user_id => current_user.id)
    end
  end

  # シフト作成
  def create
    @schedule = current_user.schedules.build(schedule_params)

    # シフト申請日存在チェック
    return @msg = 'シフトの申請に失敗しました。日付が選択されていません。' if @schedule.request_day.nil?

    # 申請先店舗には同日シフトの申請はできないようにする
    requested_check = Schedule.find_by(:user_id => @schedule.user.id, :store_id => @schedule.store.id, :request_day => @schedule.request_day)
    return @msg = "シフトの申請に失敗しました。#{@schedule.store.storename}には#{@schedule.request_day}にシフトを申請済みです。申請内容を修正してください。" unless requested_check.nil?

    # 同じ時間枠でに別店舗にシフト申請していないか確認
    # whereで日付検索
    duplicate_check = Schedule.where(:user_id => @schedule.user.id, :request_day => @schedule.request_day)
    # StringをArrayに変換 不要文字も合わせて削除
    request_timezone_array = @schedule.request_timezone.split(',').map { |m| m.delete('[]"\\\\ ') }
    # 上記でユーザIDと申請日でWhereしたものから、時間枠の重複がないか確認
    request_timezone_array.each do |timezone|
      if timezone == 'E0' || timezone == 'E1' || timezone == 'E3'
        timezone = 'E'
      end # Eの付いた時間枠はいずれも21時始まりであることから、E1,E3はEに変換して重複チェックにかかるようにする。
      duplicate_check = duplicate_check.where('request_timezone like ?', "%#{timezone}%")
    end
    # 時間枠の重複があればエラー処理 (whereの結果がemptyならその申請の時間の重複はない→申請してOK)
    return @msg = 'シフトの申請に失敗しました。別店舗に申請しているシフトと時間の重複があります。申請内容を修正してください。' unless duplicate_check.empty?

    # シフト時間枠、２４時間指定の申請がいずれも存在しない場合エラー
    if @schedule.request_timezone.empty? && @schedule.request_start_time.empty? && @schedule.request_end_time.empty?
      return @msg = 'シフトの申請に失敗しました。時間が選択されていません、申請内容を修正してください。'
    end
    # シフト２４時間指定の開始時間が存在しない場合エラー
    return @msg = 'シフトの申請に失敗しました。開始時間が選択されていません、申請内容を修正してください。' if @schedule.request_start_time.empty? && @schedule.request_end_time.present?
    # シフト２４時間指定の終了時間が存在しない場合エラー
    return @msg = 'シフトの申請に失敗しました。終了時間が選択されていません、申請内容を修正してください。' if @schedule.request_start_time.present? && @schedule.request_end_time.empty?

    # 夜勤のTimezone E0,E1,E3,Eは１つまでしか申請できないようにする（勤務時間が重複しているため）
    request_timezone_array = @schedule.request_timezone.split(',').map { |m| m.delete('[]"\\\\ ') }
    count = 0
    request_timezone_array.each do |timezone|
      count += 1 if timezone.include?('E')
    end
    return @msg = 'シフトの申請に失敗しました。E系統の勤務時間枠は１つしか選択できません' if count != 1

    # @schedule.request_timezone整形、右の文字を削除[" , [ ] ']
    unless @schedule.request_timezone.empty?
      @schedule.request_timezone.gsub!('"', '')
      @schedule.request_timezone.gsub!(',', '')
      @schedule.request_timezone.gsub!('[', '')
      @schedule.request_timezone.gsub!(']', '')
      @schedule.request_timezone.gsub!(' ', '')
    end

    @msg = if @schedule.save
             "シフトの申請ができました。申請先:#{@schedule.store.storename}　日付:#{@schedule.request_day}"
           else
             'シフトの申請に失敗しました、申請内容を修正してください。'
           end
  end

  # シフト削除
  def destroy
    @schedule = Schedule.find_by(:id => params[:id])
    @schedule.destroy
  end

  # シフト承認用UPDATE （管理者専用）
  def update
    @schedule = Schedule.find_by(:id => params[:id])

    if @schedule.approved == false
      @schedule.update_attribute(:approved, true)
    else
      @schedule.update_attribute(:approved, false)
    end
  end

  private

  # Strong parameterチェック
  def schedule_params
    # params.require(:schedule).permit(:request_day, :request_start_time, :request_end_time, :storename, :user_id, request_timezone: [] )
    # params.require(:schedule).permit(:request_day, :request_start_time, :request_end_time, :storename, request_timezone: [] )
    params.require(:schedule).permit(:request_day, :request_start_time, :request_end_time, :store_id, :request_timezone => [])
    # params.permit(:request_day, :request_start_time, :request_end_time, :store_id, request_timezone: [])
  end

  # def search_params
  #   # params.require(:q).permit(:request_day, :request_start_time, :request_end_time, :store_id, request_timezone: [])
  #   params.require(:q).permit!
  # end

  # シフト時間枠
  def timezones
    @timezones = %w[A B C D E0 E1 E3 E]
  end

  def render_schedule_calender(link_target)
    # エラーハンドリング
    schedule_nil_check = Schedule.first
    if schedule_nil_check.nil?
      flash[:error] = 'スケジュールのレコードが存在しません。'
      return redirect_to root_path
    end

    @stores = Store.all

    if params[:q].nil? # 読み込み時処理
      @users_and_schedules_search = User.ransack(params[:q])
      @users_and_schedules = @users_and_schedules_search.result
    else # 検索時処理
      # RansackでUserとScheduleをInnerJoinしたところからシフト申請店舗＆シフト申請月を検索して絞る
      # すべてのUserとScheduleを取得
      # @users_and_schedules_search = User.ransack(params[:q]) #schedulesをInnerJoinしていないのでうまく検索出来ない、下記手法で解決
      @users_and_schedules_search = User.joins(:schedules).ransack(params[:q])

      # 勤務時間帯順に並び替え
      @users_and_schedules_search.sorts = 'duty_hours asc' if @users_and_schedules_search.sorts.empty?
      @users_and_schedules = @users_and_schedules_search.result(:distinct => true).includes(:schedules) # schedulesをincludesしないと検索がうまくいかない

      # 検索対象のレコードがない場合
      if @users_and_schedules.empty?
        flash.now[:error] = 'スケジュールが存在しません。'
        return render link_target
      end

      # すべてのUserとScheduleからFirst(1 User hasmany Schedules)を取得
      @user_and_schedules_first = @users_and_schedules.first

      # 1 User hasmany SchedulesからSchedulesを取得
      @user_and_schedules_first_schedules = @user_and_schedules_first.schedules

      # 1 User hasmany Schedulesから1 Scheduleを取得
      @user_and_schedules_first_schedules_first = @user_and_schedules_first_schedules.first

      # 1 Scheduleの日付から月初と月末を抽出
      @beginningday      = @user_and_schedules_first_schedules_first.request_day.beginning_of_month
      @endday            = @user_and_schedules_first_schedules_first.request_day.end_of_month
      # 月初から月末までを変数に代入
      @beginningtoendday = @beginningday..@endday

      # シフト時間枠の配列を作成
      timezones
    end
    @check = params[:q] # 未検索時チェック
  end
end
