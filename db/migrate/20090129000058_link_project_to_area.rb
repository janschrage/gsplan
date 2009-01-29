class LinkProjectToArea < ActiveRecord::Migration
  def self.up
    add_column :projects, :projectarea_id, :integer
  end

  def self.down
    delete_column :projects, :projectarea_id
  end
end
