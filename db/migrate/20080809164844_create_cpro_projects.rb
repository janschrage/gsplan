class CreateCproProjects < ActiveRecord::Migration
  def self.up
    create_table :cpro_projects do |t|
      t.integer :project_id
      t.string :cpro_name

      t.timestamps
    end
  end

  def self.down
    drop_table :cpro_projects
  end
end
