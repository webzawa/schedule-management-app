class CreateSchedules < ActiveRecord::Migration[6.0]
  def change
    create_table :schedules do |t|
      t.date     :request_day, :null => false
      t.string   :request_timezone, :default => ''
      t.integer  :request_start_time, :default => nil
      t.integer  :request_end_time, :default => nil
      t.boolean  :approved, :default => false, :null => false

      t.timestamps
    end
  end
end
