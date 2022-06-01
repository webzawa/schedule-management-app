# ユーザ作成

password = "123456"

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
User.create!(
  :username => "芹澤誠",
  :email => "m.serizawa2064@gmail.com",
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
ScheduleCheckbox.create!(:name_for_checkbox => "A")
ScheduleCheckbox.create!(:name_for_checkbox => "B")
ScheduleCheckbox.create!(:name_for_checkbox => "C")
ScheduleCheckbox.create!(:name_for_checkbox => "D")
ScheduleCheckbox.create!(:name_for_checkbox => "E0")
ScheduleCheckbox.create!(:name_for_checkbox => "E1")
ScheduleCheckbox.create!(:name_for_checkbox => "E3")
ScheduleCheckbox.create!(:name_for_checkbox => "E")

10.times do |f|
  31.times do |n|
    user = User.find(f + 1)
    request_day = Date.current.beginning_of_month + n

    if user.duty_hours == 1
      request_timezone = 'A'
    elsif user.duty_hours == 2
      if request_day.wday == 4 || request_day.wday == 5
        request_timezone = 'C'
      else
        request_timezone = 'B'
      end
    elsif user.duty_hours == 3
      if request_day.wday == 4 || request_day.wday == 5
        request_timezone = 'D'
      else
        request_timezone = 'C'
      end
    else
      if request_day.wday == 4 || request_day.wday == 5
        request_timezone = 'E'
      else
        request_timezone = 'E3'
      end
    end

    if n <= 15
      approved = true
    else
      approved = false
    end

    if rand(3) == 1
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

