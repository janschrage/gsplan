class CreateProjects < ActiveRecord::Migration
  def self.up
    create_table :projects do |t|
      t.string :name
      t.date :planend
      t.date :planbeg
      t.integer :worktype_id
      t.integer :planeffort
      t.integer :employee_id
      t.integer :country_id

      t.timestamps
    end
  end

  def self.down
    drop_table :projects
  end
end
