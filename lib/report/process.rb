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


# Implements the reporting related to the process, such as PCT, WIP.
module Report::Process

  # Reports on process lead times for project closed between begda and endda.
  # The dates used to calculate PLT for a project are planned begin date and last update.
  def project_plt(begda,endda)
 
    project_list = []
    wip = 0

    #Find the projects
    projects = Project::find(:all, :conditions => ["planend >= ? and planend <= ? and status = ?", begda, endda, Project::StatusClosed])
    projects.each do |project|
       plt = (project.updated_at.to_date - project.planbeg).to_f
       plt_as_perc = plt / project.planeffort * 100
       projectdata  = { :project_id => project.id,
                        :name => project.name,
                        :country_id => project.country_id,
                        :planeffort => project.planeffort,
                        :plt => plt,
                        :plt_as_perc => plt_as_perc,
                        :worktype_id => project.worktype }
      project_list << projectdata
    end

    return project_list
  end

  # Calculates work in progress (WIP).
  def wip
    wip = Project.count :conditions => ["status = ? or status = ? or status = ?", Project::StatusOpen, Project::StatusInProcess, Project::StatusPilot]
    return wip
  end

  # Calculates the PCT for projects closed between begda and endda. 
  # PCT = days in interval/number of projects closed
  def pct(begda, endda)
    prj_count = Project.count :conditions => ["planend >= ? and planend <= ? and status = ?", begda, endda, Project::StatusClosed]
    
    return (endda-begda) / prj_count
  end
end