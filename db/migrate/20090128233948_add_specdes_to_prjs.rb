class AddSpecdesToPrjs < ActiveRecord::Migration
  def self.up
    add_column :projects, :srs_url, :string
    add_column :projects, :sdd_url, :string
  end

  def self.down
    remove_column :projects, :srs_url
    remove_column :projects, :sdd_url
  end
end
