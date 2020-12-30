# ユーザ作成

password = "foobar"

10.times do |n|
  if n == 0 || n == 1
    duty_hours = 1
  elsif n.between?(2,4)
    duty_hours = 2
  elsif n.between?(5,7)
    duty_hours = 3
  else
    duty_hours = 4
  end

  if duty_hours == 1
    username = "朝勤ユーザ#{n + 1}"
  elsif duty_hours == 2
    username = "昼勤ユーザ#{n + 1}"
  elsif duty_hours == 3
    username = "夕勤ユーザ#{n + 1}"
  else
    username = "夜勤ユーザ#{n + 1}"
  end

  if n == 1
    comment = "朝、昼のうちどちらか1コマでお願いします。"
  elsif n == 2
    comment = "週3,4で希望"
  elsif n == 3
    comment = "週3 土日どちらかに夕方勤務　平日は夜勤"
  elsif n == 4
    comment = "月給85000円になるようお願いします。入れる日を出している為全て入れなくても大丈夫なのですが85000円にいくようお願いします。"
  else
    comment = ""
  end

  User.create!(
    :username => username,
    :email => "test#{n + 1}@test.com",
    :duty_hours => duty_hours,
    :comment => comment,
    :password => password,
    :password_confirmation => password,
    :admin => false,
    :confirmed_at => Time.zone.now
  )
end
# 管理者 & 店長ユーザ作成
User.create!(
  :username => "店長ユーザ",
  :email => "admin@test.com",
  :duty_hours => 5,
  :password => password,
  :password_confirmation => password,
  :admin => true,
  :confirmed_at => Time.zone.now
)

# 店舗作成
3.times do |n|
  Store.create!(
    :storename => "ストア#{n + 1}店"
  )
end

# シフト申請枠作成
ScheduleCheckbox.create!(:name_for_checkbox => "6-9")
ScheduleCheckbox.create!(:name_for_checkbox => "9-13")
ScheduleCheckbox.create!(:name_for_checkbox => "13-17")
ScheduleCheckbox.create!(:name_for_checkbox => "17-21")
ScheduleCheckbox.create!(:name_for_checkbox => "21-0")
ScheduleCheckbox.create!(:name_for_checkbox => "21-1")
ScheduleCheckbox.create!(:name_for_checkbox => "21-3")
ScheduleCheckbox.create!(:name_for_checkbox => "21-6")

10.times do |f|
  31.times do |n|
    user = User.find(f + 1)
    request_day = Date.today.beginning_of_month + n

    if user.duty_hours == 1
      request_timezone = '6-9'
    elsif user.duty_hours == 2
      if request_day.wday == 4 || request_day.wday == 5
        request_timezone = '13-17'
      else
        request_timezone = '9-13'
      end
    elsif user.duty_hours == 3
      if request_day.wday == 4 || request_day.wday == 5
        request_timezone = '17-21'
      else
        request_timezone = '13-17'
      end
    else
      if request_day.wday == 4 || request_day.wday == 5
        request_timezone = '21-6'
      else
        request_timezone = '21-3'
      end
    end

    if n <= 15
      approved = true
    else
      approved = false
    end

    if rand(5) == 1
      Schedule.create!(
        :request_day => request_day,
        :request_timezone => request_timezone,
        :approved => approved,
        :store_id => 1,
        :user_id => user.id
      )
    end
  end
end
