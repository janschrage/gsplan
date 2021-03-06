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


# Implements the reporting related to projects.
module Report::Projects

  include DateHelper

  # Reports on how much time it was since projects were last updated.
  # Currently open projects only.
  def project_age_current(endda=Date::today)
    projects = list_current_projects(endda)
    projects.delete_if { |prj| prj.worktype.is_continuous }
    prj_age = []
    projects.each do |prj|
      wks_since_creation = 0

      wks_since_update = ((endda - prj.updated_at.to_date) / 7).truncate unless prj.updated_at.nil?
      wks_since_creation = ((endda - prj.created_at.to_date) / 7).truncate unless prj.created_at.nil?
      prj_age << { :project_id => prj.id,
                   :country_id => prj.country_id,
                   :wks_since_update => wks_since_update,
                   :wks_since_creation => wks_since_creation,
                   :status => prj.status,
                   :planeffort => prj.planeffort,
                   :worktype_id => prj.worktype_id }
    end
    return prj_age
  end

  # Reports on times planned vs used for projects between begda, endda
  def project_times(begda,endda)
    projectindex = {}
    projectdays = {}

    #Find the projects
    projects = Project::find(:all, :conditions => ["planend >= ? and planbeg <= ?", begda, endda])

    projects.each do |project|
       projectindex = { :id => project.id,
                        :name => project.name,
                        :country => project.country_id,
                        :planeffort => project.planeffort,
                        :daysbooked => project.days_booked(),
                        :status => project.status,
                        :worktype => project.worktype }
       projectdays[project.id] = projectindex
    end

    return projectdays
  end

  # Reports on parked projects
  # TODO implement team filter (really?)
  def parking_lot(team='*')
    projects = Project.find(:all, :conditions => ["status = ?", Project::StatusParked], :order => "updated_at")
    parking_lot = []
    projects.each do |prj|
      wks_since_creation = 0
      wks_since_update = ((Date::today - prj.updated_at.to_date) / 7).truncate
      wks_since_creation = ((Date::today - prj.created_at.to_date) / 7).truncate unless prj.created_at.nil?
      parking_lot << { :project_id => prj.id,
                       :country_id => prj.country_id,
                       :wks_since_update => wks_since_update,
                       :wks_since_creation => wks_since_creation,
                       :status => prj.status,
                       :planeffort => prj.planeffort,
                       :worktype_id => prj.worktype_id }
    end
    return parking_lot
  end

  # Pick only projects that are not closed/parked and begin date <= end date of this period, i.e. include overdue
  def list_current_projects(endda=Date.today)
    projects = Project.find(:all, :conditions => ["status != ? and status != ? and status != ?", Project::StatusClosed, Project::StatusRejected, Project::StatusParked], :order => "name" )
    projects.delete_if { |project|  project.planbeg > endda }
    return projects
  end


end
