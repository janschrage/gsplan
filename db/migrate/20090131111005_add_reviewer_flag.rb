class AddReviewerFlag < ActiveRecord::Migration
  def self.up
    add_column :employees, :is_reviewer, :boolean
  end

  def self.down
    remove_column :employees, :is_reviewer
  end
end
