# GSPlan - Team commitment planning
#
# Copyright (C) 2008 Jan Schrage <jan@jschrage.de>
# 
# This program is free software: you can redistribute it and/or modify it under the terms of the GNU 
# General Public License as published by the Free Software Foundation, either version 3 of the License,
# or (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without
# even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. 
# See the GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License along with this program. 
# If not, see <http://www.gnu.org/licenses/>.

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
    if !prevtracks.nil? 
      errors.add(:reportdate, "Track for this team/project/period/report date already exists.") unless prevtracks.id == self.id
    end
  end    
end
