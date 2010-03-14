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

class GraphController < ApplicationController
          
  include ProjectsHelper, DashboardHelper
  include Report::Worktype
  include Report::Projects

 def graph_usage
   date = Date::strptime(cookies[:report_date]) if cookies[:report_date]
   date = Date::today unless date

   # group by team and use subject as the key
   series_usage = []
   series_free = []
   teams = []
   chart = Ziya::Charts::StackedColumn.new(license = nil,"Resource Usage")

   team_list = Team.find(:all)
   team_list.each do |team|
     capa = team.capacity(date)
     if capa > 0  #only if the team has capacity this month (temporary help from other LOBs,...)
       usage = team.usage(date)
       free = [0,capa-usage].max #no negative free capacity
       series_usage << usage
       series_free << free
       teams << team.name
     end
   end
   if teams.size > 0
     chart.add :series, "Used", series_usage
     chart.add :series, "Free", series_free
     chart.add :axis_category_text, teams
   end
  
   respond_to do |fmt|
     fmt.xml { render :xml => chart.to_xml }  
   end
  end

  def graph_worktypes
    date = Date::strptime(cookies[:report_date]) if cookies[:report_date]
    date = Date::today unless date
    team_id = params[:id]
    team_id = '*' if params[:id].nil?

    worktype_distribution = calculate_worktype_distribution(date, team_id)
  
    chart = Ziya::Charts::Pie.new(license = nil,"Worktype distribution")
    
    worktypes = []
    workdays = []
    worktype_distribution.keys.each do |wt|
      wt_name = Worktype::find_by_id(wt).name
      wt_daysbooked = worktype_distribution[wt][:daysbooked]
      worktypes << wt_name
      workdays  << wt_daysbooked
   end
   
   if worktypes.size > 0
     chart.add :axis_category_text, worktypes
     chart.add :series, workdays
   else
     chart.add :axis_category_text, ["no data for work distribution"]
     chart.add :series, [0,0] 
    end

   respond_to do |fmt|
     fmt.xml { render :xml => chart.to_xml }  
   end
  end

  def graph_quintiles
   date = Date::strptime(cookies[:report_date]) if cookies[:report_date]
   date = Date::today unless date

   month = get_month_beg_end(date)
   begda = month[:first_day]
   endda = month[:last_day]

   projects = Project::find(:all, :conditions => ["planbeg <= ? and ( planend >= ? or ( status <> ? and status <> ? )) and status <> ?", endda, begda, Project::StatusClosed, Project::StatusRejected, Project::StatusParked])

   teams = Team::find(:all)
   chart = Ziya::Charts::Column.new(license = nil,"Delta planning/execution")
   values = {}

   teams.each do |team|
        values[team.id] = [0,0,0,0,0,0,0] if team.capacity(date) > 0
   end
   # group by team and use subject as the key
   chart.add :axis_category_text, ["pending", "0-20%", "20-40%", "40-60%","60-80%", ">80%", "ad-hoc"]

   projects.each do |project|
      quintile = project_quintile(project.days_committed(begda),project.days_booked(begda))
      team = project.country.team
      values[team.id][quintile] += 1 if team.capacity(date) > 0
   end
  
    teams.each do |team|
      chart.add(:series,team.name,values[team.id]) if team.capacity(date) > 0
    end
    respond_to do |fmt|
      fmt.xml { render :xml => chart.to_xml }  
    end
  end

  def graph_project_age_current
   
    chart = Ziya::Charts::Line.new(license = nil,"Project age - last update")
    projects = project_age_current
    prj_week = {}

    projects.each do |project|
      prj_week[project[:wks_since_update]] = 0 if prj_week[project[:wks_since_update]].nil?
      prj_week[project[:wks_since_update]] += 1
    end

    max_weeks=prj_week.keys.max
  

    y = []
    labels = []
    
    week=0
    (max_weeks+1).times do  
      if not prj_week[week].nil? then
        y << prj_week[week]
      else 
        y << 0
      end
      labels << week.to_s
      week += 1
    end

    ymax=y.max
  
    chart.add( :axis_category_text, labels)
    chart.add( :series,'Current projects',y)
    respond_to do |fmt|
      fmt.xml { render :xml => chart.to_xml }  
    end
  end

  def graph_project_times(begda=nil,endda=nil)
 
    begda = flash[:report_begda].to_date if begda.nil?
    endda = flash[:report_endda].to_date if endda.nil?
  
    chart = Ziya::Charts::Scatter.new(license = nil,"Planned vs. Booked")
    
    #Find the projects
    projects = Project::find(:all, :conditions => ["planend >= ? and planbeg <= ?", begda, endda])


    projects.each do |project|
      chart.add :series, '', [project.planeffort,project.days_booked()] if project.status == Project::StatusClosed
    end
    chart.add :axis_category_text, %w[x y]
    
     
    respond_to do |fmt|
      fmt.xml { render :xml => chart.to_xml }  
    end
  end
end
