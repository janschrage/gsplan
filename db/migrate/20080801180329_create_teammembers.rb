class CreateTeammembers < ActiveRecord::Migration
  def self.up
    create_table :teammembers do |t|
      t.integer :eid
      t.integer :tid
      t.date :endda
      t.date :begda

      t.timestamps
    end
  end

  def self.down
    drop_table :teammembers
  end
end
