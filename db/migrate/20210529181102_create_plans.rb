class CreatePlans < ActiveRecord::Migration[6.0]
  def change
    create_table :plans do |t|
      t.string :plan_name, :null => false, :default => ''

      t.timestamps
    end
  end
end
