class CreateWorkStores < ActiveRecord::Migration[6.0]
  def change
    create_table :work_stores do |t|
      t.references :user, :foreign_key => true
      t.references :store, :foreign_key => true
      
      t.date :join_date, :null => false, :default => ''
      t.integer :duty_hours, :null => false, :default => ''

      t.timestamps
    end
  end
end
