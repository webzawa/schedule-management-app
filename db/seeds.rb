# ユーザ作成
5.times do |n|
  User.create!(
    :username => "ユーザ#{n + 1}",
    :email => "test#{n + 1}@test.com",
    :duty_hours => 0,
    :password => 'testuser',
    :password_confirmation => 'testuser',
    :admin => false,
    :confirmed_at => Time.zone.now
  )
end

# 店舗作成
3.times do |n|
  Store.create!(
    :storename => "ストア#{n + 1}店"
  )
end

# シフト作成
31.times do |n|
  Schedule.create!(
    :request_day => "2020-08-#{n + 1}",
    :request_timezone => 'A',
    :approved => true,
    :store_id => 1,
    :user_id => 1
  )
end

31.times do |n|
  Schedule.create!(
    :request_day => "2020-08-#{n + 1}",
    :request_timezone => 'AB',
    :approved => true,
    :store_id => 1,
    :user_id => 2
  )
end

31.times do |n|
  Schedule.create!(
    :request_day => "2020-08-#{n + 1}",
    :request_start_time => 16,
    :request_end_time => 16,
    :request_timezone => 'D',
    :approved => true,
    :store_id => 1,
    :user_id => 3
  )
end

31.times do |n|
  Schedule.create!(
    :request_day => "2020-08-#{n + 1}",
    :request_timezone => 'E1',
    :approved => true,
    :store_id => 1,
    :user_id => 4
  )
end

31.times do |n|
  Schedule.create!(
    :request_day => "2020-08-#{n + 1}",
    :request_start_time => 12,
    :request_end_time => 18,
    :approved => true,
    :store_id => 1,
    :user_id => 5
  )
end
