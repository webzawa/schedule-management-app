class AddOriginalRequestTimezoneToSchedules < ActiveRecord::Migration[6.0]
  def change
    add_column :schedules, :original_request_timezone, :string, :default => ''
  end
end
