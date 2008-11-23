class SetCommitmentsOk < ActiveRecord::Migration
  def self.up
    #Set status of all existing commitments to "accepted"
    commitments = Teamcommitment.find(:all)
    commitments.each do |commitment|
      commitment.status = 1
      commitment.save!
    end
  end

  def self.down
  end
end
