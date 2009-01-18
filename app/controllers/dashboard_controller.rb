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

  include Statistics, ProjectsHelper

  def index

    @report_variables = {}

    # Default period is 3 months rolling, including current
    begda = Date.today << 2 if begda.nil?
    begda = "#{begda.year}-#{begda.month}-01".to_date
    endda = Date.today
    @report_variables = { :begda => begda,
                          :endda => endda }
  end

  def create_report
    begda = params[:report_variables][:begda].to_date
    endda = params[:report_variables][:endda].to_date

    @report_data = worktype_distribution(begda, endda)
    return true
  end

  def worktype_distribution(begda,endda)
    teams=Team.find(:all)
    curdate = begda
    wt_total = []
    until curdate > endda do
      teams.each do |team|
        wt_team_month = calculate_worktype_distribution(curdate,team.id)
        wt_team_month.keys.each do |wt|
          wt_total << { :month => Date::ABBR_MONTHNAMES[curdate.month], 
                        :team_id => team.id,
                        :worktype_id => wt,
                        :daysbooked => wt_team_month[wt][:daysbooked]} 
        end
      end

      curdate = curdate >> 1
    end
    return wt_total
  end
end
