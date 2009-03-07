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

  DaysPerPerson = 16;
  
  def get_month_beg_end(curdate)
    month_begin = Date::strptime(curdate.year().to_s+'-'+curdate.month().to_s+'-01')
    month_end = (month_begin>>(1)) - 1
    month = { :first_day => month_begin,
              :last_day  => month_end }
    return month
  end
  
  def calculate_capacities(report_date)
    # count team members
    capacity = {}
    teamindex = {}
    @teams = Team::find(:all)
    @teams.each do |@team|
      capacity[@team.name] = 0;
      teamindex[@team.id] = @team.name
    end
    teammembers = Teammember::find(:all)
    
    teammembers.each do |@teammember|
      if @teammember.endda >= report_date and @teammember.begda <= report_date then
        capacity[teamindex[@teammember.team_id]] += DaysPerPerson * (@teammember.percentage || 100)/100
      end
    end
    return capacity
  end
  
  def calculate_usage(report_date)
    # count team members
    commitmentcount = {}
    teamindex = {}
    @teams = Team::find(:all)
    @teams.each do |@team|
      commitmentcount[@team.name] = 0;
      teamindex[@team.id] = @team.name
    end

    monthbegend = get_month_beg_end(report_date)
    month_begin = monthbegend[:first_day]
    month_end = monthbegend[:last_day]

    commitments = Teamcommitment::find(:all, :conditions => ["yearmonth <= ? and yearmonth >= ? and status = ?",month_end,month_begin,Teamcommitment::StatusAccepted])
    
    
    commitments.each do |commitment|
      commitmentcount[teamindex[commitment.team_id]] += commitment.days 
    end
    return commitmentcount
  end    
  
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
    
    #Find the date of the last BW upload for the given period
    last_report_date = Projecttrack::maximum('reportdate', :conditions => ["yearmonth <= ? and yearmonth >= ?",endda, begda]) 

    #Find the projects
    projects = Project::find(:all, :conditions => ["planbeg <= ? and ( planend >= ? or status <> ? ) and status <> ?", endda, begda, Project::StatusClosed, Project::StatusParked])
    projects.each do |project|
      if team_id == '*' or countries.find_by_id(project.country_id)
        if  project.planbeg <= endda and project.planend >= begda 
          projectindex = { :name => project.name,
			   :country => project.country_id,
                           :committed_total => 0,
                           :committed_inper => 0,
                           :daysbooked => 0,
			   :reportdate => last_report_date,
                           :status => project.status,
                           :preload => project.worktype.preload }
          projectdays[project.id] = projectindex
        else
          if project.planend <= begda and project.status != Project::StatusClosed and project.status != Project::StatusParked 
                projectindex = { :name => project.name,
		                 :country => project.country_id,
                                 :committed_total => 0,
                                 :committed_inper => 0,
                                 :daysbooked => 0,
				 :reportdate => last_report_date,
                                 :status => Project::StatusOverdue,
                                 :preload => project.worktype.preload } 
                projectdays[project.id] = projectindex 
	  end
        end
      end
    end
 

    #Calculate the commitments
    commitments = Teamcommitment::find(:all)
    
    commitments.each do |commitment|
      if commitment.status == Teamcommitment::StatusAccepted then
        thisproject = projectdays[commitment.project_id]
        if  not thisproject.nil? then
          committed_total = thisproject[:committed_total] + commitment.days 
          if begda <= commitment.yearmonth and endda >= commitment.yearmonth
            committed_inper = thisproject[:committed_inper] + commitment.days
            thisproject[:committed_inper] = committed_inper
          end
          thisproject[:committed_total] = committed_total
          projectdays[commitment.project_id]=thisproject
        end
      end
    end
    
    #Calculate the days booked from the last BW data set
    tracks = Projecttrack::find(:all, :conditions => ["yearmonth <= ? and yearmonth >= ? and reportdate = ?",endda, begda, last_report_date])

    tracks.each do |track|
      thisproject = projectdays[track.project_id]
      if not thisproject.nil? then
        thisproject[:daysbooked] = thisproject[:daysbooked] + track.daysbooked
	projectdays[track.project_id] = thisproject
      end
    end
    return projectdays
  end    

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


  def get_projects_for_team_and_month(report_date)
    # Get the team of the user 
    team = Team.find_by_id(session[:team_id])
    countries = team.countries
    
    report_date=Date.today unless report_date
    month = get_month_beg_end(report_date)
    begda = month[:first_day]
    endda = month[:last_day]
    
    projectplan = calculate_project_days(report_date, team.id)

    return projectplan
  end

  def get_commitments_for_team_and_month(report_date)

    report_date=Date.today unless report_date
    month = get_month_beg_end(report_date)
    begda = month[:first_day]
    endda = month[:last_day]

    # Get the team of the user
    team_id = User.find_by_id(session[:user_id]).team_id

    commitments = Teamcommitment::find(:all, :conditions => ["team_id = ? and yearmonth >= ? and yearmonth <= ?", team_id, begda, endda])

    return commitments
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

  def project_times(begda,endda)
    projectindex = {}
    projectdays = {}

    #Find the projects
    projects = Project::find(:all, :conditions => ["planbeg >= ? and planbeg <= ?", begda, endda])
    projects.each do |project|
       projectindex = { :id => project.id,
                        :name => project.name,
                        :country => project.country_id,
                        :planeffort => project.planeffort,
                        :daysbooked => 0,
                        :status => project.status,
                        :worktype => project.worktype }
       projectdays[project.id] = projectindex
    end

    # Loop over the months
    
    curdate = begda
    wt_total = []
    until curdate > endda do
      #Find the date of the last BW upload for the given period
      month = get_month_beg_end(curdate)
      curbegda = month[:first_day]
      curendda = month[:last_day]
  
      last_report_date = Projecttrack::maximum('reportdate', :conditions => ["yearmonth <= ? and yearmonth >= ?",curendda, curbegda]) 
  
      #Calculate the days booked from the last BW data set
      tracks = Projecttrack::find(:all, :conditions => ["yearmonth <= ? and yearmonth >= ? and reportdate = ?",curendda, curbegda, last_report_date])
  
      tracks.each do |track|
        thisproject = projectdays[track.project_id]
        if not thisproject.nil? then
          thisproject[:daysbooked] = thisproject[:daysbooked] + track.daysbooked
          projectdays[track.project_id] = thisproject
        end
      end
      curdate = curdate >> 1
    end
    return projectdays
  end

  def parking_lot(team='*')
  # Reports on parked projects
    projects = Project.find(:all, :conditions => ["status = ?", Project::StatusParked], :order => "updated_at")
    parking_lot = []
    projects.each do |prj|
      wks_since_update = ((Date::today - prj.updated_at.to_date) / 7).truncate
      wks_since_creation = ((Date::today - prj.created_at.to_date) / 7).truncate
      parking_lot << { :project_id => prj.id,
                       :country_id => prj.country_id,
                       :wks_since_update => wks_since_update,
                       :wks_since_creation => wks_since_creation,
                       :status => prj.status,
                       :planeffort => prj.planeffort,
                       :worktype_id => prj.worktype_id }
    end
    return parking_lot
  end
end

