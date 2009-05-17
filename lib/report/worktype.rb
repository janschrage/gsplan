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


# Implements the reporting related to work distribution over the various work types.
module Report::Worktype

  include Report::DateHelpers

  # Implements a tracking report for distribution of work types per team and month
  # between begda and endda.
  def worktype_tracking(begda,endda)
    teams=Team.find(:all)
    curdate = begda
    wt_total = []
    until curdate > endda do
      teams.each do |team|
        wt_team_month = calculate_worktype_distribution(curdate,team.id)
        # get the total time and calculate percentages
        sum_of_times_booked = 0
        wt_team_month.keys.each do |wt|
          sum_of_times_booked += wt_team_month[wt][:daysbooked]
        end

        wt_team_month.keys.each do |wt|
          perc = (wt_team_month[wt][:daysbooked] / sum_of_times_booked)*100
          wt_total << { :month => Date::ABBR_MONTHNAMES[curdate.month], 
                        :team_id => team.id,
                        :worktype_id => wt,
                        :daysbooked => wt_team_month[wt][:daysbooked],
                        :perc => perc} 
        end
      end

      curdate = curdate >> 1
    end
    return wt_total
  end

  # Implements a cumulative report for distribution of work types per team 
  # between begda and endda.
  def worktype_cumul(begda,endda)
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
      # get the total time and calculate percentages
      sum_of_times_booked = 0
      wt_team.keys.each do |wt|
        sum_of_times_booked += wt_team[wt][:daysbooked]
      end

      wt_team.keys.each do |wt|
        perc = (wt_team[wt][:daysbooked]/sum_of_times_booked)*100
        wt_total << { :team_id => team.id,
                      :worktype_id => wt,
                      :daysbooked => wt_team[wt][:daysbooked],
                      :perc => perc }
      end
    end
    return wt_total
  end

  # Calculates the distribution of work for a team and month.
  # If team=='*' all teams are cumulated.
  def calculate_worktype_distribution(report_date, team_id = '*')

    if report_date then
      month = get_month_beg_end(report_date)
      begda = month[:first_day]
      endda = month[:last_day]
    else
      begda = Date::strptime('1900-01-01')
      endda = Date::strptime('9999-12-31')
    end
    
    #Find the date of the last BW upload for the given period
    last_report_date = Projecttrack::maximum('reportdate', :conditions => ["yearmonth <= ? and yearmonth >= ?",endda, begda]) 
  
    #Calculate the days booked from the last BW data set
    tracks = Projecttrack::find(:all, :conditions => ["yearmonth <= ? and yearmonth >= ? and reportdate = ?",endda, begda, last_report_date])

    wt_distrib = {}

    tracks.each do |track|
      if (team_id == '*') or (track.team_id.to_s == team_id.to_s) then
        wt = Project.find_by_id(track.project_id).worktype_id
        if wt_distrib[wt].nil?
          wt_distrib[wt] = { :daysbooked => track.daysbooked }
        else
	  wt_distrib[wt][:daysbooked] = wt_distrib[wt][:daysbooked] + track.daysbooked 
        end
      end
    end
    return wt_distrib
  end

end
