class CreateProjecttracks < ActiveRecord::Migration
  def self.up
    create_table :projecttracks do |t|
      t.integer :team_id
      t.date :yearmonth
      t.integer :project_id
      t.date :reportdate
      t.integer :daysbooked

      t.timestamps
    end
  end

  def self.down
    drop_table :projecttracks
  end
end
