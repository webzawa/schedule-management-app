# frozen_string_literal: true

module PagesHelper
  def schedule_pick(user, day)
    schedule = ''
    schedule_record = Schedule.find_by(user_id: user, request_day: day, approved: true)
    #レコードがない場合は処理をしない
    unless schedule_record == nil

      #レコードのTimezone,starttime,endtimeが空でない場合
      if schedule_record.request_timezone != nil && schedule_record.request_start_time != "" && schedule_record.request_end_time != ""
        #scheduleにTimezone,starttime,endtimeを代入
        schedule = "#{schedule_record.request_timezone}#{schedule_record.request_start_time}-#{schedule_record.request_end_time}"
      else
        #レコードのTimezoneが空でない場合
        unless schedule_record.request_timezone == nil
          #scheduleにTimezoneを代入
          schedule = schedule_record.request_timezone
        #レコードのTimezoneが空だった場合(starttime,endtimeがある)
        else
          #scheduleにstarttime,endtimeを代入
          schedule = schedule_record.request_start_time + "-" + schedule_record.request_end_time
        end
      end

    end
  end
end
