class AddCommentToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :comment, :string, :default => ''
  end
end
