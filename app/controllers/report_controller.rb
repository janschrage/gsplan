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

  include DateHelper,ProjectsHelper
 
  def index
    @report_date = Date.today
    monthbegend = get_month_beg_end(@report_date)
    cookies[:report_date]=@report_date.to_s
    
    @allprojects = Project.find(:all, :conditions => ["(status != ? and status != ? and status != ?) or (status = ? and planend >= ?)",Project::StatusClosed, Project::StatusRejected, Project::StatusParked, Project::StatusClosed, monthbegend[:last_day]], :order => "name" )
    @allprojects.delete_if { |project|  project.planbeg > monthbegend[:last_day] or project.days_booked(@report_date)==0}

  end

   
end
