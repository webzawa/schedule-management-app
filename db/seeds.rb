# ユーザ作成
30.times do |n|
  User.create!(
    :username => "ユーザ#{n + 1}",
    :email => "test#{n + 1}@test.com",
    :duty_hours => 0,
    :password => '123456',
    :password_confirmation => '123456',
    :admin => false,
    :confirmed_at => Time.zone.now
  )
end
User.create!(
  :username => "管理者ユーザ",
  :email => "admin@test.com",
  :duty_hours => 0,
  :password => '123456',
  :password_confirmation => '123456',
  :admin => true,
  :confirmed_at => Time.zone.now
)

# 店舗作成
3.times do |n|
  Store.create!(
    :storename => "ストア#{n + 1}店"
  )
end

# シフト作成
31.times do |n|
  Schedule.create!(
    :request_day => "2020-11-#{n + 1}",
    :request_timezone => 'ADE',
    :approved => true,
    :store_id => 1,
    :user_id => 1
  )
end

31.times do |n|
  Schedule.create!(
    :request_day => "2020-11-#{n + 1}",
    :request_timezone => 'BC',
    :approved => false,
    :store_id => 1,
    :user_id => 2
  )
end

# シフト申請枠作成
ScheduleCheckbox.create!(:name_for_checkbox => "A")
ScheduleCheckbox.create!(:name_for_checkbox => "B")
ScheduleCheckbox.create!(:name_for_checkbox => "C")
ScheduleCheckbox.create!(:name_for_checkbox => "D")
ScheduleCheckbox.create!(:name_for_checkbox => "E")
ScheduleCheckbox.create!(:name_for_checkbox => "E0")
ScheduleCheckbox.create!(:name_for_checkbox => "E1")
ScheduleCheckbox.create!(:name_for_checkbox => "E3")
