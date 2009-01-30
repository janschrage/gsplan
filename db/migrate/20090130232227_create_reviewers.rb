class CreateReviewers < ActiveRecord::Migration
  def self.up
    create_table :reviewers do |t|
      t.column :project_id, :integer
      t.column :employee_id, :integer
    end
  end

  def self.down
    drop table :reviewers
  end
end
