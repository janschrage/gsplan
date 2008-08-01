class CreateWorktypes < ActiveRecord::Migration
  def self.up
    create_table :worktypes do |t|
      t.string :name
      t.string :description
      t.boolean :preload

      t.timestamps
    end
  end

  def self.down
    drop_table :worktypes
  end
end
