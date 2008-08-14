class MakeDaysDecimal < ActiveRecord::Migration
  def self.up
    change_column :projects, :planeffort, :decimal, :precision => 7, :scale => 2
    change_column :teamcommitments, :days, :decimal, :precision => 5, :scale => 2
    change_column :projecttracks, :daysbooked, :decimal, :precision => 5, :scale => 2
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
