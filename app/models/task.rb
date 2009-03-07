class Task < ActiveRecord::Base
  belongs_to :teamcommitment
  belongs_to :employee

  validates_presence_of :employee_id, :teamcommitment_id
  validate :task_is_unique, :ee_exists, :commitment_exists

protected
  def task_is_unique
    dev=Task.find(:all, :conditions => ['employee_id = ? and teamcommitment_id = ?',employee_id,teamcommitment_id])
    errors.add(:project_id,'This employee already has this task.') unless dev.blank?
  end

  def ee_exists
    ee=Employee.find_by_id(employee_id)
    errors.add(:employee_id,'Employee does not exist.') if ee.nil?
  end
 
  def commitment_exists
    tc=Teamcommitment.find_by_id(teamcommitment_id)
    errors.add(:teamcommitment_id,'Commitment does not exist.') if tc.nil?
  end

end
