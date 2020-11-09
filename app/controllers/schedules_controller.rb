# frozen_string_literal: true

class SchedulesController < ApplicationController
  before_action :authenticate_user!
  before_action :admin_user, :only => [:approveschedule, :update]

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
    timehours
    @stores = Store.all # 全店舗呼び出し
    @users  = User.all  # 全ユーザ呼び出し

    if params[:q].nil? # 読み込み時処理
      @schedules_search = Schedule.ransack(params[:q])
      @schedules_search.sorts = 'request_day desc' if @schedules_search.sorts.blank?
      @schedules = @schedules_search.result.includes(%i[user store]).page(params[:page])
    else # 検索時処理
      @schedules_search = Schedule.ransack(params[:q])
      @schedules_search.sorts = 'request_day desc' if @schedules_search.sorts.blank?
      @schedules = @schedules_search.result.includes(%i[user store]).page(params[:page])
    end
    @check = params[:q] # 未検索時チェック
  end

  # シフト作成
  def create
    # @schedule = current_user.schedules.build(schedule_params) # 2020/09/03要望により削除
    @schedule = Schedule.new(schedule_params)

    # シフト申請日存在チェック
    return @msg = '日付が選択されていません。' if @schedule.request_day.nil?

    # 申請先店舗には同日シフトの申請はできないようにする
    requested_check = Schedule.find_by(:user_id => @schedule.user.id, :store_id => @schedule.store.id, :request_day => @schedule.request_day)
    return @msg = "#{@schedule.store.storename}には#{@schedule.request_day}にシフトを申請済みです。申請内容を修正してください。" unless requested_check.nil?

    # シフト時間枠、２４時間指定の申請がいずれも存在しない場合エラー
    return @msg = '時間が選択されていません、申請内容を修正してください。' if @schedule.request_timezone.blank? && @schedule.request_start_time.blank? && @schedule.request_end_time.blank?
    # シフト２４時間指定の開始時間が存在しない場合エラー
    return @msg = '開始時間が選択されていません、申請内容を修正してください。' if @schedule.request_start_time.blank? && @schedule.request_end_time.present?
    # シフト２４時間指定の終了時間が存在しない場合エラー
    return @msg = '終了時間が選択されていません、申請内容を修正してください。' if @schedule.request_start_time.present? && @schedule.request_end_time.blank?

    # 夜勤のTimezone E0,E1,E3,Eは１つまでしか申請できないようにする（勤務時間が重複しているため）
    request_timezone_array = @schedule.request_timezone.split(',').map { |m| m.delete('[]"\\\\ ') }
    count = 0 # カウンタ初期化
    request_timezone_array.each do |timezone|
      count += 1 if timezone.include?('E') # Eが含まれるTimezoneを申請していたらカウントする
      return @msg = 'E系統の勤務時間帯は１つしか選択できません' if count >= 2 # countが2以上であればE勤の重複あり、エラー処理
    end

    # timehours関連エラーハンドリング
    if @schedule.request_start_time.present? || @schedule.request_end_time.present?
      return @msg = '勤務開始時間が終了時間を上回っています。申請内容を修正してください。' if @schedule.request_start_time > @schedule.request_end_time
    end

    # 2020/09/03　要望により削除
    # # 同じ時間枠でに別店舗にシフト申請していないか確認
    # # whereで日付検索
    # schedule_of_other_stores = Schedule.where(:user_id => @schedule.user.id, :request_day => @schedule.request_day)
    # if schedule_of_other_stores.present? # 同日、他店舗にシフト申請済みの場合
    #   # StringをArrayに変換 不要文字も合わせて削除
    #   request_timezone_array = @schedule.request_timezone.split(',').map { |m| m.delete('[]"\\\\ ') }
    #   # 上記でユーザIDと申請日でWhereしたものから、時間枠の重複がないか確認
    #   request_timezone_array.each do |timezone|
    #     if timezone == 'E0' || timezone == 'E1' || timezone == 'E3'
    #       timezone = 'E'
    #     end # Eの付いた時間枠はいずれも21時始まりであることから、E1,E3はEに変換して重複チェックにかかるようにする。
    #     duplicate_check_timezone = schedule_of_other_stores.where('request_timezone like ?', "%#{timezone}%")
    #     # 時間枠の重複があればエラー処理 (whereの結果がemptyならその申請の時間の重複はない→申請してOK)
    #     return @msg = '別店舗に申請しているシフトと時間の重複があります。申請内容を修正してください。' if duplicate_check_timezone.present?
    #   end

    #   # timehoursが他店舗申請済みシフトと重複しているか判定
    #   if @schedule.request_start_time.present? || @schedule.request_end_time.present?
    #     schedule_of_other_stores.each do |schedule_of_other_store| # 1店舗ずつ取り出し
    #       if @schedule.request_start_time.between?(schedule_of_other_store.request_start_time, schedule_of_other_store.request_end_time)
    #         return @msg = "#{schedule_of_other_store.store.storename}に申請しているシフトと開始時間の重複があります。申請内容を修正してください。"
    #       end
    #       if @schedule.request_end_time.between?(schedule_of_other_store.request_start_time, schedule_of_other_store.request_end_time)
    #         return @msg = "#{schedule_of_other_store.store.storename}に申請しているシフトと終了時間の重複があります。申請内容を修正してください。"
    #       end
    #     end
    #   end
    # end

    # @schedule.request_timezone整形、右の文字を削除[" , [ ] ']
    if @schedule.request_timezone.present?
      @schedule.request_timezone.gsub!('"', '')
      @schedule.request_timezone.gsub!(',', '')
      @schedule.request_timezone.gsub!('[', '')
      @schedule.request_timezone.gsub!(']', '')
      @schedule.request_timezone.gsub!(' ', '')
    end

    @msg = if @schedule.save
             @created = true
             "シフトの申請ができました。申請先:#{@schedule.store.storename}　日付:#{@schedule.request_day}"
           else
             'シフトの申請に失敗しました、申請内容を修正してください。'
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

    # respond_to do |format|
    #   if @schedule.update(schedule_params2)
    #     flash[:success] = "シフトを編集しました。ユーザ:#{@schedule.user.username}　店舗:#{@schedule.store.storename}　日付:#{@schedule.request_day}"
    #     format.html { redirect_to @@request_referer }
    #   else
    #     flash[:error] = "シフトの編集に失敗しました。ユーザ:#{@schedule.user.username}　店舗:#{@schedule.store.storename}　日付:#{@schedule.request_day}"
    #     format.html { redirect_to @@request_referer }
    #   end
    # end
  end

  private

  # Strong parameterチェック
  def schedule_params
    params.require(:schedule).permit(
      :user_id,
      :store_id,
      :approved,
      :request_day,
      :request_start_time,
      :request_end_time,
      :request_timezone => []
    )
  end

  def schedule_params2
    params.require(:schedule).permit(
      :user_id,
      :store_id,
      :approved,
      :request_day,
      :request_start_time,
      :request_end_time,
      :request_timezone
    )
  end

  # シフト時間枠
  def timezones
    @timezones = %w[A B C D E0 E1 E3 E]
  end

  def timehours
    @timehours = 0..24
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
      @users_and_schedules_search = User.joins(:schedules).ransack(params[:q])

      # 勤務時間帯順に並び替え
      @users_and_schedules_search.sorts = 'duty_hours asc' if @users_and_schedules_search.sorts.blank?
      @users_and_schedules = @users_and_schedules_search.result(:distinct => true).includes(:schedules) # schedulesをincludesしないと検索がうまくいかない

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
    end
    @check = params[:q] # 未検索時チェック
  end
end
