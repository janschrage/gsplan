class CreateTasks < ActiveRecord::Migration
  def self.up
    create_table :tasks do |t|
      t.integer :teamcommitment_id
      t.integer :employee_id
    end
  end

  def self.down
    drop_table :tasks
  end
end
