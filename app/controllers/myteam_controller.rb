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

class MyteamController < ApplicationController

  include Statistics, MyteamHelper

  def index
    # filter by team
    team_id = User.find_by_id(session[:user_id]).team_id
    if team_id.nil? then
      flash[:error] = "You are not assigned to a team."
      #redirect_to :controller => "teamcommitments", :action => "index"
      redirect_to :back
      return false
    end
    session[:team_id] = team_id  

    if params[:report_date]
      @report_date =  Date::strptime(params[:report_date])
    else
      if cookies[:report_date]
        @report_date =  Date::strptime(cookies[:report_date])
      end
    end
    @report_date = Date.today unless @report_date
    cookies[:report_date]=@report_date.to_s

    @projectplan = get_projects_for_team_and_month(@report_date)
    commitments = get_commitments_for_team_and_month(@report_date)
    firstproject = @projectplan[@projectplan.keys.first]
    @last_report_date = firstproject[:reportdate]

    session[:original_uri] = request.request_uri

    @missingdays = {}
    @projectplan.keys.each do |project_id|
      @missingdays[project_id] = Project.find_by_id(project_id).planeffort - @projectplan[project_id][:committed_total]
    end
    @projectplan = @projectplan.sort{|a,b| a[1][:country]<=>b[1][:country]}

    @outputlist = []
    commitments.each do |commitment| 
        team = Team.find_by_id(commitment.team_id)
        teamname = team.name unless team == nil
        project = Project.find_by_id(commitment.project_id)
        projectname = project.name unless project == nil
        output = { :classname => commitment,
                   :id => commitment.id,
                   :teamname => teamname, 
                   :yearmonth => commitment.yearmonth,
                   :projectname => projectname,
                   :days => commitment.days,
                   :status => commitment.status,
                   :preload => project.worktype.preload }
        @outputlist << output
    end

    @currentprojects = team_projects_current

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => [@projects,@outputlist] }
    end
  end
end
