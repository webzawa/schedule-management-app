class CreateScheduleCheckboxes < ActiveRecord::Migration[6.0]
  def change
    create_table :schedule_checkboxes do |t|
      t.string   :name_for_checkbox, :default => ''
      t.timestamps
    end
  end
end
