class AddStatusToProject < ActiveRecord::Migration
  def self.up
    add_column :projects, :status, :integer, :limit => 1
  end

  def self.down
    remove_column :projects, :status
  end
end
