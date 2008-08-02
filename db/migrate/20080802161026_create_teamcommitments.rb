class CreateTeamcommitments < ActiveRecord::Migration
  def self.up
    create_table :teamcommitments do |t|
      t.integer :team_id
      t.date :yearmonth
      t.integer :project_id
      t.integer :days

      t.timestamps
    end
  end

  def self.down
    drop_table :teamcommitments
  end
end
