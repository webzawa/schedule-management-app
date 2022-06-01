class CreateSchedules < ActiveRecord::Migration[6.0]
  def change
    create_table :schedules do |t|
      t.references :work_store, :foreign_key => true

      t.date     :request_day, :null => false
      t.string   :request_time, :default => ''
      t.integer  :approved, :default => false, :null => false

      t.timestamps
    end
  end
end
