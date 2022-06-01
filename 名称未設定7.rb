class CreateInquiries < ActiveRecord::Migration[6.0]
  def change
    create_table :inquiries do |t|
      t.references :user, :foreign_key => true
      t.text :inquiry_comment

      t.timestamps
    end
  end
end