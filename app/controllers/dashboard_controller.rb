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

class DashboardController < ApplicationController

  include Statistics, DashboardHelper, TeamcommitmentsHelper

  def index

    @report_variables = {}

    # Default period is 3 months rolling, including current
    begda = Date.today << 2 if begda.nil?
    begda = "#{begda.year}-#{begda.month}-01".to_date
    endda = Date.today
    @report_variables = { :begda => begda,
                          :endda => endda,
                          :report_type => RepWT_Tracking }
  end

  def create_report
    begda = params[:report_variables][:begda].to_date
    endda = params[:report_variables][:endda].to_date

    flash[:report_begda] = params[:report_variables][:begda]
    flash[:report_endda] = params[:report_variables][:endda]

    @report_type = params[:report_variables][:report_type].to_i

    case @report_type
      when RepWT_Tracking: @report_data = worktype_distribution_tracking(begda, endda)
      when RepWT_Cumul:    @report_data = worktype_distribution_cumul(begda, endda)
      when RepPRJ_Time_since_update: @report_data = project_age_current
      when RepPRJ_Project_times: @report_data = project_times(begda,endda)
      when RepPRJ_Parked: @report_data = parking_lot('*') #all teams
      when RepPRJ_Cycle_times: 
        @report_data = project_pct(begda,endda)
        @wip = project_wip
    end
    return true
  end

end
