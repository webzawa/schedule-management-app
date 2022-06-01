# frozen_string_literal: true

class SchedulesController < ApplicationController
  before_action :authenticate_user!
  before_action :admin_user, :only => [:approveschedule, :editschedule, :update, :edit, :update_to_edit_schedule]

  # シフト表ページ
  def workschedule
    render_schedule_calender('workschedule')
  end

  # 申請済みシフトの承認ページ（管理者専用）
  def approveschedule
    render_schedule_calender('approveschedule')
  end

  # 申請済みシフトの編集ページ（管理者専用）
  def editschedule
    render_schedule_calender('editschedule')
  end

  # シフト原本表示ページ（管理者専用）
  def originalschedule
    render_schedule_calender('originalschedule')
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
    @users  = User.all  # 全ユーザ呼び出し
    @user   = User.find(current_user.id)

    if params[:q].nil? # 読み込み時はRansack用のparamsが空なので当日月のスケジュールを出す用の値を格納
      params[:q] = { :user_id_eq => current_user.id }
    end

    @schedules_search = Schedule.ransack(params[:q])
    @schedules_search.sorts = 'request_day desc' if @schedules_search.sorts.blank?
    @schedules = @schedules_search.result.includes(%i[user store]).page(params[:page])

    @check = params[:q] # 未検索時チェック
  end

  # シフト作成
  def create
    # シフト申請日存在チェック
    return @msg = '日付が選択されていません。' if params[:schedule][:request_day][0].blank?

    # シフト時間枠の申請がいずれも存在しない場合エラー
    return @msg = '時間が選択されていません、申請内容を修正してください。' if params[:schedule][:request_timezone].blank?

    # 日付を配列に分割
    request_day_array = params[:schedule][:request_day][0].split(',')

    request_day_array.each do |request_day|
      @schedule = Schedule.new(schedule_params)
      @schedule.request_day = request_day

      # 申請先店舗には同日シフトの申請はできないようにする
      requested_check = Schedule.find_by(:user_id => @schedule.user.id, :store_id => @schedule.store.id, :request_day => @schedule.request_day)
      return @msg = "#{@schedule.store.storename}には#{@schedule.request_day}にシフトを申請済みです。申請内容を修正してください。" unless requested_check.nil?

      # 夜勤のTimezone E0,E1,E3,Eは１つまでしか申請できないようにする（勤務時間が重複しているため）
      request_timezone_array = @schedule.request_timezone.split(',').map { |m| m.delete('[]"\\\\ ') }
      count = 0 # カウンタ初期化
      request_timezone_array.each do |timezone|
        count += 1 if timezone.include?('E') # Eが含まれるTimezoneを申請していたらカウントする
        return @msg = 'E系統の勤務時間帯は１つしか選択できません' if count >= 2 # countが2以上であればE勤の重複あり、エラー処理
      end

      # @schedule.request_timezone整形、右の文字を削除[" , [ ] ']
      if @schedule.request_timezone.present?
        @schedule.request_timezone.gsub!('"', '')
        @schedule.request_timezone.gsub!(',', '')
        @schedule.request_timezone.gsub!('[', '')
        @schedule.request_timezone.gsub!(']', '')
        @schedule.request_timezone.gsub!(' ', '')
      end

      @schedule.original_request_timezone = @schedule.request_timezone

      @msg = if @schedule.save
               @created = true
               "シフトの申請ができました。申請先:#{@schedule.store.storename}"
             else
               'シフトの申請に失敗しました、申請内容を修正してください。'
             end
    end
  end

  # シフト削除
  def destroy
    # 自分以外のシフトは削除不可にする。（管理者は可とする。）
    unless current_user.admin?
      destroy_schedule_check = current_user.schedules.find_by(:id => params[:id])
      return if destroy_schedule_check.nil?
    end
    @schedule = Schedule.find_by(:id => params[:id])
    @msg = if @schedule.destroy
             @deleted = true
             "シフトを削除しました。ユーザ:#{@schedule.user.username}　店舗:#{@schedule.store.storename}　日付:#{@schedule.request_day}"
           else
             "シフトを削除に失敗しました。ユーザ:#{@schedule.user.username}　店舗:#{@schedule.store.storename}　日付:#{@schedule.request_day}"
           end
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

  def edit
    @schedule = Schedule.find_by(:id => params[:id])
    # @@request_referer = request.referer
  end

  def update_to_edit_schedule
    @schedule = Schedule.find_by(:id => params[:id])
    @msg = if @schedule.update(schedule_params2)
             @edited = true
             "シフトを編集しました。ユーザ:#{@schedule.user.username}　店舗:#{@schedule.store.storename}　日付:#{@schedule.request_day}"
           else
             "シフトを編集に失敗しました。ユーザ:#{@schedule.user.username}　店舗:#{@schedule.store.storename}　日付:#{@schedule.request_day}"
           end
  end

  private

  # Strong parameterチェック
  def schedule_params
    params.require(:schedule).permit(
      :user_id,
      :store_id,
      :approved,
      :request_day => [],
      :request_timezone => []
    )
  end

  def schedule_params2
    params.require(:schedule).permit(
      :user_id,
      :store_id,
      :approved,
      :request_day,
      :request_timezone
    )
  end

  # シフト時間枠
  def timezones
    @timezones = ScheduleCheckbox.order(:id => 'ASC').pluck(:name_for_checkbox)
  end

  def render_schedule_calender(link_target)
    if link_target == 'workschedule' || link_target == 'originalschedule'
      @visualization = false
    end

    # エラーハンドリング
    schedule_nil_check = Schedule.first
    if schedule_nil_check.nil?
      flash[:error] = 'スケジュールのレコードが存在しません。'
      return redirect_to root_path
    end

    @stores = Store.all

    if params[:q].nil? # 読み込み時はRansack用のparamsが空なので当日月のスケジュールを出す用の値を格納
      if link_target == 'workschedule'
        if current_user.work_store.present?
          params[:q] = { :schedules_store_id_eq => current_user.work_store,
                         :schedules_request_day_during_year_month => Date.current.beginning_of_month,
                         :schedules_approved_eq => "true"
                       }
        else
          params[:q] = { :schedules_store_id_eq => "1",
                         :schedules_request_day_during_year_month => Date.current.beginning_of_month,
                         :schedules_approved_eq => "true"
                       }
        end
      else
        if current_user.work_store.present?
          params[:q] = { :schedules_store_id_eq => current_user.work_store,
                         :schedules_request_day_during_year_month => Date.current.beginning_of_month,
                         :schedules_approved_eq => nil
                       }
        else
          params[:q] = { :schedules_store_id_eq => "1",
                         :schedules_request_day_during_year_month => Date.current.beginning_of_month,
                         :schedules_approved_eq => nil
                       }
        end
      end
    end

    @users_and_schedules_search = User.ransack(params[:q])
    @users_and_schedules = @users_and_schedules_search.result(:distinct => true).order(Arel.sql('join_date IS NULL, join_date ASC')).includes(:schedules)
    if @users_and_schedules.blank?
      flash.now[:error] = 'スケジュールが存在しません。'
      return render link_target
    end

    # RansackでUserとScheduleをInnerJoinしたところからシフト申請店舗＆シフト申請月を検索して絞る
    # すべてのUserとScheduleを取得
    @users_and_schedules_search = User.joins(:schedules).ransack(params[:q])

    @searched_approved = params[:q][:schedules_approved_eq] #schedules_helperで使用　シフトのカウントは「承認可否」の「未選択」「承認済」「未承認」で変化する。
    @searched_store    = params[:q][:schedules_store_id_eq]

    # 勤務時間帯順に並び替え
    @users_and_schedules_search.sorts = 'duty_hours asc' if @users_and_schedules_search.sorts.blank?
    # 下記部分はschedulesをincludesしないと検索がうまくいかない。さらに、User入店時期順、アプリ登録順で昇順ソートするよう設定。
    @users_and_schedules = @users_and_schedules_search.result(:distinct => true).order(Arel.sql('join_date IS NULL, join_date ASC')).includes(:schedules)
    # 検索対象のレコードがない場合
    if @users_and_schedules.blank?
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

    @check = params[:q] # 未検索時チェック
  end
end
