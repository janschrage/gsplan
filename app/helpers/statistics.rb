 module Statistics
 
  def get_month_beg_end(curdate)
    month_begin = Date::strptime(curdate.year().to_s+'-'+curdate.month().to_s+'-01')
    month_end = (month_begin>>(1)) - 1
    month = { :first_day => month_begin,
              :last_day  => month_end }
    return month
  end
  
  def calculate_capacities(report_date)
    # count team members
    membercount = {}
    teamindex = {}
    @teams = Team::find(:all)
    @teams.each do |@team|
      membercount[@team.name] = 0;
      teamindex[@team.id] = @team.name
    end
    teammembers = Teammember::find(:all)
    
    teammembers.each do |@teammember|
      if @teammember.endda >= report_date then
        membercount[teamindex[@teammember.team_id]] += 1*16
      end
    end
    return membercount
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
    # count team members
    commitmentcount = {}
    projectindex = {}
    
    if report_date then
      month = get_month_beg_end(report_date)
      begda = month[:first_day]
      endda = month[:last_day]
    else
      begda = Date::strptime('1900-01-01')
      endda = Date::strptime('9999-12-31')
    end
    
    @projects = Project::find(:all)
    @projects.each do |project|
      if  project.planbeg <= endda and project.planend >= begda 
        commitmentcount[project.name] = 0;
        projectindex[project.id] = project.name
      end
    end
    commitments = Teamcommitment::find(:all)
    
    
    commitments.each do |commitment|
      if projectindex[commitment.project_id] then
        commitmentcount[projectindex[commitment.project_id]] += commitment.days 
      end
    end
    return commitmentcount
  end    
end