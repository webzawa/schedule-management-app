class CreateOriginalSchedules < ActiveRecord::Migration[6.0]
  def change
    create_table :original_schedules do |t|
      t.references :schedules, :foreign_key => true

      t.date     :request_day, :null => false
      t.string   :request_time, :default => ''
      t.integer  :approved, :default => false, :null => false

      t.timestamps
    end
  end
end
