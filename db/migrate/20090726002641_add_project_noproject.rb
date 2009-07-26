class AddProjectNoproject < ActiveRecord::Migration
  def self.up
    add_column :worktypes, :is_continuous, :boolean
  end

  def self.down
    remove_column :worktypes, :is_continuous
  end
end
