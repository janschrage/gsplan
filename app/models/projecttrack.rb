class Projecttrack < ActiveRecord::Base
  
  belongs_to :team
  belongs_to :project
  validates_presence_of :team_id, :project_id, :reportdate, :daysbooked, :yearmonth
  validates_numericality_of :daysbooked
  validate :daysbooked_is_positive, :track_is_in_project_timeframe, :no_crystal_ball, :track_is_unique
  
protected
  def daysbooked_is_positive
    errors.add(:daysbooked, "Days booked must be >0") if daysbooked.nil? || daysbooked <= 0
  end
  
  def track_is_in_project_timeframe
    project = Project.find_by_id(project_id) 
    return if project.nil?
    if yearmonth < project.planbeg or yearmonth > project.planend
      errors.add(:yearmonth, "The booked days must be within the timeframe of the project ("+project.planbeg.to_s+" - "+project.planend.to_s+").")
    end
  end

  def no_crystal_ball
    return if yearmonth.nil? or reportdate.nil?
    errors.add(:yearmonth, "This booking is for the future. Your crystal ball just shattered.") if yearmonth > reportdate
  end
  
  def track_is_unique
    return if yearmonth.nil? or project_id.nil? or team_id.nil? or reportdate.nil?
    prevtracks = Projecttrack.find(:first, :conditions => ["project_id = ? and team_id = ? and yearmonth = ? and reportdate = ?", project_id, team_id, yearmonth, reportdate])
    errors.add(:reportdate, "Track for this team/project/period/report date already exists.") if !prevtracks.nil?
  end    
end
