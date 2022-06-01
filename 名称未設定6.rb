class CreateRequests < ActiveRecord::Migration[6.0]
  def change
    create_table :requests do |t|
      t.references :work_store, :foreign_key => true

      t.date     :request_comment, :null => false

      t.timestamps
    end
  end
end
