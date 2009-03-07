class CreateDevelopers < ActiveRecord::Migration
  def self.up
    create_table :developers do |t|
      t.integer :teamcommitment_id
      t.integer :employee_id
    end
  end

  def self.down
    drop_table :developers
  end
end
