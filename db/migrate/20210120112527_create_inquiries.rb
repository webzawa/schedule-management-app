class CreateInquiries < ActiveRecord::Migration[6.0]
  def change
    create_table :inquiries do |t|
      t.text :request_comment
      t.date :request_day, :null => false
      t.references :user, :foreign_key => true

      t.timestamps
    end
  end
end