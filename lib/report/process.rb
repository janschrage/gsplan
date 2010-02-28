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
       if !project.worktype.is_continuous
        plt = (project.updated_at.to_date - project.planbeg + 1).to_f
        projectdata  = { :project_id => project.id,
                         :name => project.name,
                         :country_id => project.country_id,
                         :planeffort => project.planeffort,
                         :plt => plt,
                         :worktype_id => project.worktype }
        project_list << projectdata
      end
    end

    return project_list
  end

  # Calculates work in progress (WIP).
  def wip
    projects = Project::find(:all, :conditions => ["status = ? or status = ? or status = ?", Project::StatusOpen, Project::StatusInProcess, Project::StatusPilot])
    projects.delete_if { |prj| prj.worktype.is_continuous }
    wip = projects.size
    return wip
  end

  # Calculates the PCT for projects closed between begda and endda. 
  # PCT = days in interval/number of projects closed
  def pct(begda, endda)
    projects = Project::find(:all, :conditions => ["planend >= ? and planend <= ? and status = ?", begda, endda, Project::StatusClosed])
    projects.delete_if { |prj| prj.worktype.is_continuous }
    prj_count = projects.size
    return 0 if prj_count == 0
    return (((endda-begda) + 1) / prj_count).to_i
  end
end