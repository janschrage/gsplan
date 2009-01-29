class CreateProjectareas < ActiveRecord::Migration
  def self.up
    create_table :projectareas do |t|
      t.string :area

      t.timestamps
    end
  end

  def self.down
    drop_table :projectareas
  end
end
