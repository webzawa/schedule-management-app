# frozen_string_literal: true

class AddColumnNameToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :name, :string
  end
end
