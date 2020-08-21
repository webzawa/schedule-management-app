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

3.times do |n|
  Store.create!(
    :storename => "ストア#{n + 1}店"
  )
end

30.times do |n|
  Schedule.create!(
    :request_day => "2020-08-#{n + 1}",
    :request_timezone => 'A',
    :approved => true,
    :store_id => 1,
    :user_id => 1
  )
end
