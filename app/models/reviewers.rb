class Reviewers < ActiveRecord::Base
  belongs_to :project
  belongs_to :employee

  validates_presence_of :employee_id, :project_id
  validate :reviewer_is_unique, :ee_exists, :prj_exists

protected
  def reviewer_is_unique
    rev=Reviewers.find(:all, :conditions => ['employee_id = ? and project_id = ?',employee_id,project_id])
    errors.add(:project_id,'Reviewer already has this project.') unless rev.blank?
  end

  def ee_exists
    ee=Employee.find_by_id(employee_id)
    errors.add(:employee_id,'Employee does not exist.') if ee.nil?
  end
 
  def prj_exists
    prj=Project.find_by_id(project_id)
    errors.add(:project_id,'Project does not exist.') if prj.nil?
  end
end
