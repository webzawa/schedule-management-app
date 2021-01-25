# frozen_string_literal: true

module SchedulesHelper
  def countschedule_check(store, day, timezone, searched_approved) # 申請済みのスケジュールを時間枠ごとにカウント（不足シフトの可視化のために必要）

    if searched_approved.blank?
      schedule_count_records = Schedule.where(:store_id => store, :request_day => day)
    else
      schedule_count_records = Schedule.where(:store_id => store, :request_day => day, :approved => searched_approved)
    end

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

  def salary_calculation(user, beginday, endday, searched_approved)

    if searched_approved.blank?
      schedules_of_month = Schedule.where(:user_id => user.id, :request_day => beginday..endday)
    else
      schedules_of_month = Schedule.where(:user_id => user.id, :request_day => beginday..endday, :approved => searched_approved)
    end

    timezones = ScheduleCheckbox.pluck(:name_for_checkbox) #ScheduleCheckbox内容を配列化
    hourly_pay = 1012
    night_duty_hourly_pay_of_magnification = 1.25
    salarycount_result = 0
    timezones.each do |timezone|
      salarycount = 0
      if timezone == "A"
        searched_timezone = schedules_of_month.where('request_timezone like ?', "%#{timezone}%")
        unless searched_timezone.count == 0
          salarycount = searched_timezone.count * hourly_pay * 3
        end
      elsif timezone == "B" || timezone == "C" || timezone == "D"
        searched_timezone = schedules_of_month.where('request_timezone like ?', "%#{timezone}%")
        unless searched_timezone.count == 0
          salarycount = searched_timezone.count * hourly_pay * 4
        end
      elsif timezone == "E0"
        searched_timezone = schedules_of_month.where('request_timezone like ?', "%#{timezone}%")
        unless searched_timezone.count == 0
          salarycount = searched_timezone.count * hourly_pay * 1 + searched_timezone.count * hourly_pay * 2 * night_duty_hourly_pay_of_magnification
        end
      elsif timezone == "E1"
        searched_timezone = schedules_of_month.where('request_timezone like ?', "%#{timezone}%")
        unless searched_timezone.count == 0
          salarycount = searched_timezone.count * hourly_pay * 1 + searched_timezone.count * hourly_pay * 3 * night_duty_hourly_pay_of_magnification
        end
      elsif timezone == "E3"
        searched_timezone = schedules_of_month.where('request_timezone like ?', "%#{timezone}%")
        unless searched_timezone.count == 0
          salarycount = searched_timezone.count * hourly_pay * 1 + searched_timezone.count * hourly_pay * 5 * night_duty_hourly_pay_of_magnification - hourly_pay * 0.75
        end
      elsif timezone == "E"
        searched_timezone = schedules_of_month.where('request_timezone like ?', "%#{timezone}")
        unless searched_timezone.count == 0
          salarycount = searched_timezone.count * hourly_pay * 1 + searched_timezone.count * hourly_pay * 8 * night_duty_hourly_pay_of_magnification - hourly_pay * 1
        end
      else
        #何もしない
      end
      salarycount_result = salarycount_result + salarycount
    end
    # byebug
    return number_to_currency(salarycount_result.round)
  end


  def salary_calculation_of_store(store, beginday, endday, searched_approved)

    if searched_approved.blank?
      schedules_of_month = Schedule.where(:store_id => store, :request_day => beginday..endday)
    else
      schedules_of_month = Schedule.where(:store_id => store, :request_day => beginday..endday, :approved => searched_approved)
    end

    timezones = ScheduleCheckbox.pluck(:name_for_checkbox) #ScheduleCheckbox内容を配列化
    hourly_pay = 1012
    night_duty_hourly_pay_of_magnification = 1.25
    salarycount_result = 0
    timezones.each do |timezone|
      salarycount = 0
      if timezone == "A"
        searched_timezone = schedules_of_month.where('request_timezone like ?', "%#{timezone}%")
        unless searched_timezone.count == 0
          salarycount = searched_timezone.count * hourly_pay * 3
        end
      elsif timezone == "B" || timezone == "C" || timezone == "D"
        searched_timezone = schedules_of_month.where('request_timezone like ?', "%#{timezone}%")
        unless searched_timezone.count == 0
          salarycount = searched_timezone.count * hourly_pay * 4
        end
      elsif timezone == "E0"
        searched_timezone = schedules_of_month.where('request_timezone like ?', "%#{timezone}%")
        unless searched_timezone.count == 0
          salarycount = searched_timezone.count * hourly_pay * 1 + searched_timezone.count * hourly_pay * 2 * night_duty_hourly_pay_of_magnification
        end
      elsif timezone == "E1"
        searched_timezone = schedules_of_month.where('request_timezone like ?', "%#{timezone}%")
        unless searched_timezone.count == 0
          salarycount = searched_timezone.count * hourly_pay * 1 + searched_timezone.count * hourly_pay * 3 * night_duty_hourly_pay_of_magnification
        end
      elsif timezone == "E3"
        searched_timezone = schedules_of_month.where('request_timezone like ?', "%#{timezone}%")
        unless searched_timezone.count == 0
          salarycount = searched_timezone.count * hourly_pay * 1 + searched_timezone.count * hourly_pay * 5 * night_duty_hourly_pay_of_magnification
        end
      elsif timezone == "E"
        searched_timezone = schedules_of_month.where('request_timezone like ?', "%#{timezone}")
        unless searched_timezone.count == 0
          salarycount = searched_timezone.count * hourly_pay * 1 + searched_timezone.count * hourly_pay * 8 * night_duty_hourly_pay_of_magnification
        end
      else
        #何もしない
      end
      salarycount_result = salarycount_result + salarycount
    end
    # byebug
    return "計#{number_to_currency(salarycount_result.round)}"
  end

  def number_to_currency(price)
    "#{price.to_s(:delimited, delimiter: ',')}円"
  end

end
