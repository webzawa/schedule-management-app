class CreateSchedules < ActiveRecord::Migration[6.0]
  def change
    create_table :schedules do |t|
      t.integer :user_id
      t.time :request_day_and_time
      t.boolean :approved

      t.timestamps
    end
  end
end
