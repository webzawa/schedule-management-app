class CreateStores < ActiveRecord::Migration[6.0]
  def change
    create_table :stores do |t|
      t.string :storename, :null => false, :default => ""

      t.timestamps
    end
  end
end
