 module Statistics
 
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
      if @teammember.endda >= report_date then
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
    commitments = Teamcommitment::find(:all)
    
    monthbegend = get_month_beg_end(report_date)
    month_begin = monthbegend[:first_day]
    month_end = monthbegend[:last_day]
    
    commitments.each do |commitment|
      if commitment.yearmonth >= month_begin and commitment.yearmonth <= month_end then
        commitmentcount[teamindex[commitment.team_id]] += commitment.days 
      end
    end
    return commitmentcount
  end    
  
  def calculate_project_days(report_date)
    # count project days committed between dates and total
    projectindex = {}
    projectdays = {}
    
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
    @projects = Project::find(:all, :conditions => ["planbeg <= ? and ( planend >= ? or status <> ? ) ", endda, begda, Project::StatusClosed])
    @projects.each do |project|
        if  project.planbeg <= endda and project.planend >= begda 
          projectindex = { :name => project.name,
			                     :country => project.country_id,
                           :committed_total => 0,
                           :committed_inper => 0,
                           :daysbooked => 0,
			   :reportdate => last_report_date,
                           :status => project.status }
          projectdays[project.id] = projectindex                 
        else
          if project.planend <= begda and project.status != Project::StatusClosed
                projectindex = { :name => project.name,
		                           	 :country => project.country_id,
                                 :committed_total => 0,
                                 :committed_inper => 0,
                                 :daysbooked => 0,
				 :reportdate => last_report_date,
                                 :status => Project::StatusOverdue } 
                projectdays[project.id] = projectindex                 
	        end
        end
    end
 

    #Calculate the commitments
    commitments = Teamcommitment::find(:all)
    
    commitments.each do |commitment|
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

  def calculate_worktype_distribution(report_date)

    # Get the bookings per project
    projectdays = calculate_project_days(report_date)
  
    wt_distrib = {}

    projectdays.each do |project|
      wt = Project.find_by_id(project[0]).worktype_id
      if wt_distrib[wt].nil?
	wt_distrib[wt] = { :daysbooked => project[1][:daysbooked],
			   :committed_inper => project[1][:committed_inper] }
      else
	wt_distrib[wt][:daysbooked] = wt_distrib[wt][:daysbooked] + project[1][:daysbooked]
	wt_distrib[wt][:committed_inper] = wt_distrib[wt][:committed_inper] + project[1][:committed_inper] 
      end
    end
    return wt_distrib
  end
end

