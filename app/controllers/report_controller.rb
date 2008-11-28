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

class ReportController < ApplicationController

  include Statistics, Graphs, ProjectsHelper
 
  def index
    # Get/Set the report date
    if params[:report_date]
      @report_date =  Date::strptime(params[:report_date])
    else
      if cookies[:report_date]
        @report_date =  Date::strptime(cookies[:report_date])
      end
    end
    @report_date = Date.today unless @report_date
          
    cookies[:report_date]=@report_date.to_s
    
    
    @projectplan = calculate_project_days(@report_date)
    firstproject = @projectplan[@projectplan.keys.first]
    @last_report_date = firstproject[:reportdate]


    @graph_quint = open_flash_chart_object(500,300,"/report/graph_quintiles")

  end
   
end
