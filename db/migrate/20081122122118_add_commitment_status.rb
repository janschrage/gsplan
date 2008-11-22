class AddCommitmentStatus < ActiveRecord::Migration
  def self.up

    add_column :teamcommitments, :status, :integer, :limit => 1

    right_create_commitment = Right.create :name => "create_commitment", :controller => "teamcommitments", :action => "create"
    role_tl = Role.find_by_name("Teamlead")
    role_tl.rights << right_create_commitment
    role_tl.save!
  end

  def self.down
    remove_column :teamcommitments, :status
  end
end
