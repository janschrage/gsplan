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

module MyteamHelper

  def team_projects_current
    # Pick only projects that are not closed and begin date <= end date of this period, i.e. include overdue
    # Only projects for this team
    projects = Project.find(:all, :conditions => ["status != ? and status != ?", Project::StatusClosed, Project::StatusRejected], :order => "name" )
    endda = Date::strptime(cookies[:report_date]) || Date.today
    projects.delete_if { |project|  project.planbeg > endda }

    countries = Team.find(session[:team_id]).countries
    currentprojects = []

    projects.each do |project|
      currentprojects << project if countries.find_by_id(project.country_id)
    end
       
    return currentprojects
  end
end
