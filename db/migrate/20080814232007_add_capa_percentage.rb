class AddCapaPercentage < ActiveRecord::Migration
  def self.up
    add_column :teammembers, :percentage, :integer
  end

  def self.down
    remove_column :teammembers, :percentage
  end
end
