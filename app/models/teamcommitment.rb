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

class Teamcommitment < ActiveRecord::Base
  
  include Statistics

  StatusType = Struct.new(:id,:name)

  StatusProposed = 0
  StatusAccepted = 1

  belongs_to :team
  belongs_to :project
  has_many   :tasks
  has_many   :employees, :through => :tasks
  
  validates_presence_of :team_id, :project_id, :yearmonth, :days
  validates_numericality_of :days
  validate :commitment_is_in_project_timeframe, :commitment_is_positive, :commitment_is_unique, :project_is_in_process

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
    if project.nil?
      errors.add(:project_id,'The project does not exist')  
      return false
    end
    if yearmonth < project.planbeg or yearmonth > project.planend
      errors.add(:yearmonth, 'The commitment must be within the timeframe of the project ('+project.planbeg.to_s+' - '+project.planend.to_s+').')
    end
  end
  
  def commitment_is_positive
    errors.add(:days, 'Commitments must be >0') if days.nil? || days <= 0
  end
  
  def commitment_is_unique
    if yearmonth.nil?
      errors.add(:yearmonth,'The date must be filled')  
      return false
    end 
    prevcommitments = Teamcommitment.find(:all, :conditions => ["project_id = ? and team_id = ?", project_id, team_id])
    month=get_month_beg_end(yearmonth)
    prevcommitments.each do |prev|
      if month[:first_day] <= prev.yearmonth and month[:last_day] >= prev.yearmonth
        errors.add(:yearmonth, "Commitment for this team/project/period already exists.") unless prev.id == self.id
      end
    end
  end

  def project_is_in_process
    project = Project.find_by_id(project_id) 
    if project.nil?
      errors.add(:project_id,'The project does not exist')  
      return false
    end
    errors.add(:project_id, 'The project must be in process or in testing.') unless project.status==Project::StatusInProcess or project.status==Project::StatusPilot
  end
end
