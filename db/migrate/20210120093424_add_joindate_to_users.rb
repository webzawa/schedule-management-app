class AddJoindateToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :join_date, :date, :default => nil
  end
end
