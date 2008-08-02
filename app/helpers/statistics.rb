 module Statistics
 
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
    
    month_begin = report_date; month_begin=month_begin-30
    month_end = report_date; month_end=month_end+20
    
    commitments.each do |commitment|
      if commitment.yearmonth >= month_begin and commitment.yearmonth <= month_end then
        commitmentcount[teamindex[commitment.team_id]] += commitment.days 
      end
    end
    return commitmentcount
  end    
  
  def calculate_project_days
    # count team members
    commitmentcount = {}
    projectindex = {}
    @projects = Project::find(:all)
    @projects.each do |@project|
      commitmentcount[@project.name] = 0;
      projectindex[@project.id] = @project.name
    end
    commitments = Teamcommitment::find(:all)
    
    
    commitments.each do |commitment|
      commitmentcount[projectindex[commitment.project_id]] += commitment.days 
    end
    return commitmentcount
  end    
end