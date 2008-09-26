class AddTeamToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :team_id, :integer
    add_column :countries, :team_id, :integer
  end

  def self.down
    remove_column :users, :team_id    
    remove_column :countries, :team_id
  end
end
