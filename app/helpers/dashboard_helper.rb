module DashboardHelper

  include Statistics

  ReportType = Struct.new(:report_type, :name)

  RepWT_Tracking = 1
  RepWT_Cumul = 2
  RepPRJ_Time_since_update = 3
  RepPRJ_Project_times = 4
  RepPRJ_Parked = 5
  RepPRJ_Cycle_times = 6

  ReportTypes = []
  ReportTypes << ReportType.new(RepWT_Tracking,"Work types tracking")
  ReportTypes << ReportType.new(RepWT_Cumul,"Work types cumulative")
  ReportTypes << ReportType.new(RepPRJ_Time_since_update,"Projects - time since update")
  ReportTypes << ReportType.new(RepPRJ_Project_times,"Project times")
  ReportTypes << ReportType.new(RepPRJ_Parked,"Parked projects")
  ReportTypes << ReportType.new(RepPRJ_Cycle_times,"Process cycle times")


  def report_type_list
    return ReportTypes
  end

## Here come the reports

  def worktype_distribution_tracking(begda,endda)
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

  def project_pct(begda,endda)
  # Reports on process cycle times for project closed between begda, endda and work in progress
 
    project_list = []
    wip = 0

    #Find the projects
    projects = Project::find(:all, :conditions => ["planend >= ? and planend <= ? and status = ?", begda, endda, Project::StatusClosed])
    projects.each do |project|
       pct = (project.updated_at.to_date - project.planbeg).to_f
       pct_as_perc = pct / project.planeffort * 100
       projectdata  = { :project_id => project.id,
                        :name => project.name,
                        :country_id => project.country_id,
                        :planeffort => project.planeffort,
                        :pct => pct,
                        :pct_as_perc => pct_as_perc,
                        :worktype_id => project.worktype }
      project_list << projectdata
    end

    return project_list
  end

  def project_wip
    wip = Project.count :conditions => ["status = ? or status = ? or status = ?", Project::StatusOpen, Project::StatusInProcess, Project::StatusPilot]
    return wip
  end

  def avg_pct(prj_list)
    prj_count = 0
    sum_pct = 0

    prj_list.each do |prj|
      sum_pct += prj[:pct]
      prj_count += 1
    end
    
    return sum_pct / prj_count
  end
end
