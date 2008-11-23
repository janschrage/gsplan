class CreateReviews < ActiveRecord::Migration
  def self.up
    create_table :reviews do |t|
      t.integer :project_id
      t.text :notes
      t.integer :user_id
      t.integer :rtype
      t.integer :result

      t.timestamps
    end

    add_column :worktypes, :needs_review, :boolean

  end

  def self.down
    drop_table :reviews
  end
end
