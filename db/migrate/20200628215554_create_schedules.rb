class CreateSchedules < ActiveRecord::Migration[6.0]
  def change
    create_table :schedules do |t|
      t.date :request_day
      t.time :request_start_time
      t.time :request_end_time
      t.string :request_timezone
      t.boolean :approved

      t.timestamps
    end
  end
end
