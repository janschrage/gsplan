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
    @report_type = params[:report_variables][:report_type].to_i

    case @report_type
      when RepWT_Tracking: @report_data = worktype_distribution_tracking(begda, endda)
      when RepWT_Cumul:    @report_data = worktype_distribution_cumul(begda, endda)
      when RepPRJ_Time_since_update: @report_data = project_age_current
    end
    return true
  end

  def worktype_distribution_tracking(begda,endda)
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

  def worktype_distribution_cumul(begda,endda)
    teams=Team.find(:all)
    wt_total = []
    teams.each do |team|
      curdate = begda
      wt_team = {}
      until curdate > endda do
        wt_month = calculate_worktype_distribution(curdate,team.id)
        wt_month.keys.each do |wt|
          if wt_team[wt].nil?
            wt_team[wt] = { :daysbooked => wt_month[wt][:daysbooked] }
          else
	    wt_team[wt][:daysbooked] = wt_team[wt][:daysbooked] + wt_month[wt][:daysbooked] 
          end
        end
        curdate = curdate >> 1
      end
      wt_team.keys.each do |wt|
        wt_total << { :team_id => team.id,
                      :worktype_id => wt,
                      :daysbooked => wt_team[wt][:daysbooked] }
      end
    end
    return wt_total
  end

  def project_age_current
  # Reports on how much time it was since projects were last updated
  # currently open projects only
    projects = project_list_current
    prj_age = []
    projects.each do |prj|
      wks_since_update = ((Date::today - prj.updated_at.to_date) / 7).truncate
      wks_since_creation = ((Date::today - prj.created_at.to_date) / 7).truncate
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
end
