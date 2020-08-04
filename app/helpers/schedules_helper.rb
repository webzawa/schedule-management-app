# frozen_string_literal: true

module SchedulesHelper
  # def schedule_pick(user, day)
  #   schedule = ''
  #   schedule_record = Schedule.find_by(user_id: user, request_day: day, approved: true)
  #   #レコードがない場合は処理をしない
  #   unless schedule_record == nil

  #     #レコードのTimezone,starttime,endtimeが空でない場合
  #     if schedule_record.request_timezone != nil && schedule_record.request_start_time != "" && schedule_record.request_end_time != ""
  #       #scheduleにTimezone,starttime,endtimeを代入
  #       schedule = "#{schedule_record.request_timezone}#{schedule_record.request_start_time}-#{schedule_record.request_end_time}"
  #     else
  #       #レコードのTimezoneが空でない場合
  #       unless schedule_record.request_timezone == nil
  #         #scheduleにTimezoneを代入
  #         schedule = schedule_record.request_timezone
  #       #レコードのTimezoneが空だった場合(starttime,endtimeがある)
  #       else
  #         #scheduleにstarttime,endtimeを代入
  #         schedule = schedule_record.request_start_time + "-" + schedule_record.request_end_time
  #       end
  #     end
  #   end
  # end

  def countschedule_check(store, day, timezone) #申請済みのスケジュールを時間枠ごとにカウント（不足シフトの可視化のために必要）
    schedule_count = ''
    schedule_count_records = Schedule.where(store_id: store, request_day: day)

    # if timezone == "E1" or timezone == "E3"
    if timezone == "E" #E1やE3を判定しないよう条件分岐、後部ワイルドカード(%)を削除
      schedule_count_records = schedule_count_records.where('request_timezone like ?', "%#{timezone}")
    else
      schedule_count_records = schedule_count_records.where('request_timezone like ?', "%#{timezone}%")
    end

    if schedule_count_records.count == 0
      schedule_count = nil
    else
      schedule_count = schedule_count_records.count
    end
  end
end
