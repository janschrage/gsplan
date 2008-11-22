class Teamcommitment < ActiveRecord::Base
  
  include Statistics

  StatusType = Struct.new(:id,:name)

  StatusProposed = 0
  StatusAccepted = 1

  belongs_to :team
  belongs_to :project
  
  validates_presence_of :team_id, :project_id, :yearmonth, :days
  validates_numericality_of :days
  validate :commitment_is_in_project_timeframe, :commitment_is_positive, :commitment_is_unique

  def commitment_status_text(status)
    if status == nil
      statustext = "not set"
    else
      statustext = commitment_status_list[status][1]
    end
    return statustext             
  end
  
  def commitment_status_list
    @statuslist = []
    @statuslist << StatusType.new(StatusProposed, "proposed")
    @statuslist << StatusType.new(StatusAccepted, "accepted")
    return @statuslist
  end
 
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
  
  def commitment_is_unique
    return if yearmonth.nil?
    prevcommitments = Teamcommitment.find(:all, :conditions => ["project_id = ? and team_id = ?", project_id, team_id])
    month=get_month_beg_end(yearmonth)
    prevcommitments.each do |prev|
      if month[:first_day] <= prev.yearmonth and month[:last_day] >= prev.yearmonth
        errors.add(:yearmonth, "Commitment for this team/project/period already exists.") unless prev.id == self.id
      end
    end
  end
end
