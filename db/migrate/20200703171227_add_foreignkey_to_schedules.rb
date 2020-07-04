class AddForeignkeyToSchedules < ActiveRecord::Migration[6.0]
  def change
    add_reference :schedules, :store, foreign_key: true
    add_reference :schedules, :user,  foreign_key: true
    add_index     :schedules, [:id, :user_id], unique: true
  end
end
