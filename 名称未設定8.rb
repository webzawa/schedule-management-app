class CreateWorkingHours < ActiveRecord::Migration[6.0]
  def change
    create_table :working_hours do |t|
      t.references :store, :foreign_key => true
      t.string   :working_hour, :default => ''
      t.timestamps
    end
  end
end
