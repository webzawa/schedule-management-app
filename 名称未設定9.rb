class CreateWages< ActiveRecord::Migration[6.0]
  def change
    create_table :wages do |t|
      t.references :working_hours, :foreign_key => true
      t.integer   :wage, :default => ''
      t.timestamps
    end
  end
end
