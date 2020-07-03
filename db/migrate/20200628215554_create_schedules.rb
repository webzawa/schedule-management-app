class CreateSchedules < ActiveRecord::Migration[6.0]
  def change
    create_table :schedules do |t|
      t.date :request_day
      t.string :request_start_time
      t.string :request_end_time
      t.string :request_timezone
      t.boolean :approved

      t.timestamps
    end
  end
end
