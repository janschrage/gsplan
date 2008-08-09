class Teamcommitment < ActiveRecord::Base
  belongs_to :team
  belongs_to :project
  
  validates_presence_of :team_id, :project_id, :yearmonth, :days
  validates_numericality_of :days
  validate :commitment_is_in_project_timeframe, :commitment_is_positive
 
protected
  def commitment_is_in_project_timeframe
    project = Project.find_by_id(project_id) 
    return if project.nil?
    if yearmonth < project.planbeg or yearmonth > project.planend
      errors.add(:yearmonth, "The commitment must be within the timeframe of the project ("+project.planbeg.to_s+" - "+project.planend.to_s+").")
    end
  end
  
  def commitment_is_positive
    errors.add(:days, "Commitments must be >0") if days.nil? || days <= 0
  end
end
