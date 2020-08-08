# frozen_string_literal: true

module SchedulesHelper
  def countschedule_check(store, day, timezone) # 申請済みのスケジュールを時間枠ごとにカウント（不足シフトの可視化のために必要）
    schedule_count_records = Schedule.where(:store_id => store, :request_day => day)

    schedule_count_records = if timezone == 'E' # E0、E1、E3を判定しないよう条件分岐、後部ワイルドカード(%)を削除
                               schedule_count_records.where('request_timezone like ?', "%#{timezone}")
                             else
                               schedule_count_records.where('request_timezone like ?', "%#{timezone}%")
                             end

    schedule_count = if schedule_count_records.count == 0 # countが0なら表示しない
                       nil
                     else
                       schedule_count_records.count
                     end
  end
end
