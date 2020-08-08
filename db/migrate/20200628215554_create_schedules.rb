class CreateSchedules < ActiveRecord::Migration[6.0]
  def change
    create_table :schedules do |t|
      t.date    :request_day       , :null => false
      t.string  :request_start_time, :default => ""
      t.string  :request_end_time  , :default => ""
      t.string  :request_timezone  , :default => ""
      t.boolean :approved          , :default => false, :null => false

      t.timestamps
    end
  end
end
