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

class Teammember < ActiveRecord::Base
  
  belongs_to :team
  belongs_to :employee
  validates_presence_of :employee_id, :team_id, :begda, :endda, :percentage 
  validates_numericality_of :percentage
  validate :begda_is_before_endda, :percentage_is_valid
  
 def teamname
    @team = Team.find_by_id(team_id)
    "#{@team.name}"
  end

  def eename
    @employee = Employee.find_by_id(employee_id)
    "#{@employee.name}"
  end
  
  def countMembers(team_id,report_date)
    members = []
    members=@self.find_by_team_id(team_id)
    members.each do |member| 
      if member.endda >= report_date then
         count=count+1 
      end
    end
    return count
  end
  
protected
  def begda_is_before_endda
    return if begda.nil? or endda.nil?
    errors.add(:endda, "End date must not be before begin date.") if begda > endda
  end
  
  def percentage_is_valid
    return if percentage.nil?
    errors.add(:percentage, "Percentage must be between 0 and 100.") if percentage < 0 or percentage > 100
  end
end
