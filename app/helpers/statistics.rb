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

module Statistics
 
  include TeamcommitmentsHelper
  include Report::DateHelpers

  # TODO: Refactor. Is a report. And ugly.
  def calculate_project_days(report_date, team_id = '*')
    # count project days committed between dates and total
    projectindex = {}
    projectdays = {}
	
    # identify countries to check based on team
    if team_id != '*' then
	countries = Team::find_by_id(team_id).countries
    else
        countries = Country::find(:all)
    end

    if report_date then
      month = get_month_beg_end(report_date)
      begda = month[:first_day]
      endda = month[:last_day]
    else
      begda = Date::strptime('1900-01-01')
      endda = Date::strptime('9999-12-31')
    end

    last_report_date = Projecttrack::maximum('reportdate', :conditions => ["yearmonth <= ? and yearmonth >= ?",endda, begda]) 

    #Find the projects
    projects = Project::find(:all, :conditions => ["planbeg <= ? and ( planend >= ? or ( status <> ? and status <> ? )) and status <> ?", endda, begda, Project::StatusClosed, Project::StatusRejected, Project::StatusParked])
    projects.each do |project|
      if team_id == '*' or countries.find_by_id(project.country_id)
        projectindex = { :name => project.name,
	                 :country => project.country_id,
                         :committed_total => project.days_committed,
                         :committed_inper => project.days_committed(begda),
                         :daysbooked => project.days_booked(begda),
			 :reportdate => last_report_date,
                         :status => project.status,
                         :preload => project.worktype.preload }
        projectindex[:status] = Project::StatusOverdue if project.planend <= begda and project.status != Project::StatusClosed and project.status != Project::StatusParked and project.status != Project::StatusRejected and project.status != Project::StatusProposed        
        
        projectdays[project.id] = projectindex

      end
    end

    return projectdays
  end    


  #TODO: Refactor.
  def get_projects_for_team_and_month(report_date)
    # Get the team of the user 
    team = Team.find_by_id(session[:team_id])
    countries = team.countries unless team.nil?
    
    report_date=Date.today unless report_date
    month = get_month_beg_end(report_date)
    begda = month[:first_day]
    endda = month[:last_day]
    
    teamid = team.nil? ? '*' : team.id
    projectplan = calculate_project_days(report_date, teamid)

    return projectplan
  end

end

