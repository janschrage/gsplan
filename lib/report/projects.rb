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

  include Report::DateHelpers

  # Reports on how much time it was since projects were last updated.
  # Currently open projects only.
  def project_age_current
    projects = list_current_projects
    prj_age = []
    projects.each do |prj|
      wks_since_creation = 0

      wks_since_update = ((Date::today - prj.updated_at.to_date) / 7).truncate
      wks_since_creation = ((Date::today - prj.created_at.to_date) / 7).truncate unless prj.created_at.nil?
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
    projects = Project::find(:all, :conditions => ["planbeg >= ? and planbeg <= ?", begda, endda])
    projects.each do |project|
       projectindex = { :id => project.id,
                        :name => project.name,
                        :country => project.country_id,
                        :planeffort => project.planeffort,
                        :daysbooked => 0,
                        :status => project.status,
                        :worktype => project.worktype }
       projectdays[project.id] = projectindex
    end

    # Loop over the months
    curdate = begda
    wt_total = []
    until curdate > endda do
      #Find the date of the last BW upload for the given period
      month = get_month_beg_end(curdate)
      curbegda = month[:first_day]
      curendda = month[:last_day]
  
      last_report_date = Projecttrack::maximum('reportdate', :conditions => ["yearmonth <= ? and yearmonth >= ?",curendda, curbegda]) 
  
      #Calculate the days booked from the last BW data set
      tracks = Projecttrack::find(:all, :conditions => ["yearmonth <= ? and yearmonth >= ? and reportdate = ?",curendda, curbegda, last_report_date])
  
      tracks.each do |track|
        thisproject = projectdays[track.project_id]
        if not thisproject.nil? then
          thisproject[:daysbooked] = thisproject[:daysbooked] + track.daysbooked
          projectdays[track.project_id] = thisproject
        end
      end
      curdate = curdate >> 1
    end
    return projectdays
  end

  # Reports on parked projects
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