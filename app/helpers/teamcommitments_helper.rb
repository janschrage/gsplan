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

module TeamcommitmentsHelper
  
  TeamcommitmentStatusImages = [ "/images/icons/agt_announcements.png",
                                 "/images/icons/ok.png" ]    

  def project_list_current
    # This is for the selection in edit/create. 
    # Pick only projects that are not closed and begin date <= end date of this period, i.e. include overdue
    @projects = Project.find(:all, :conditions => ["status != ? and status != ?", Project::StatusClosed, Project::StatusRejected], :order => "name" )
    endda = Date::strptime(cookies[:report_date]) || Date.today
    @projects.delete_if { |project|  project.planbeg > endda }
    return @projects
  end
  
  def team_list
    @teams = Team.find(:all, :order => "name" )
    return @teams
  end
  

  def country_by_id(country_id)
    return Country.find_by_id(country_id)
  end

  def teamcommitment_status_image(status)
    return "/images/icons/cache.png" if status.nil?
    return TeamcommitmentStatusImages[status]
  end

end
