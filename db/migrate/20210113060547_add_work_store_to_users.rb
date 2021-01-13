class AddWorkStoreToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :work_store, :integer, :default => nil
  end
end
