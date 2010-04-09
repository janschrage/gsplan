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

  include DateHelper,MyteamHelper

  def index

    # filter by team
    user = User.find_by_id(session[:user_id])
    team_id = user.team_id unless user.nil?
    if team_id.nil? then
      flash[:error] = "You are not assigned to a team."
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
        
    @team = Team.find_by_id(team_id)
    teamname = @team.name unless @team == nil
    commitments = @team.commitments(@report_date)
    session[:original_uri] = request.request_uri

    #Only show for current month
    monthbegend = get_month_beg_end(@report_date)
    month_begin = monthbegend[:first_day]
    month_end = monthbegend[:last_day]

    @teamcommitments = commitments.sort{|a,b| a.team_id<=>b.team_id}

    @currentprojects = team_projects_current
    @allprojects = @currentprojects
    @currentprojects.delete_if { |project| project.worktype.needs_review != true }

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => [@projects,@outputlist] }
    end
  end
end
