class Review < ActiveRecord::Base


  ResultFail           = 0
  ResultOK             = 1
  ResultOKwithComments = 2
  ResultPartial        = 3

  ReviewSpec   = 0
  ReviewDesign = 1
  ReviewCode   = 2
  #ReviewAT     = 3

  belongs_to :project
  validates_presence_of :user_id, :project_id, :notes, :result
  validate :project_is_in_process, :project_needs_review


protected
  def project_is_in_process
    project = Project.find_by_id(project_id)
    if project.nil?
      errors.add(:project_id, "Project not found.")
      return false
    end
    errors.add(:project_id, "Project must be in process.") if project.status != Project::StatusInProcess
  end

  def project_needs_review
    project = Project.find_by_id(project_id)
    if project.nil?
      errors.add(:project_id, "Project not found.")
      return false
    end
    return false if project.worktype.nil? 
    errors.add(:project_id, "This type of work does not need a review.") unless project.worktype.needs_review
  end

end
