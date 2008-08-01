class Teammember < ActiveRecord::Migration
  def self.up
    rename_column :teammembers, :eid, :employee_id
    rename_column :teammembers, :tid, :team_id
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
