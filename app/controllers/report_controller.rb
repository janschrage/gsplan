class ReportController < ApplicationController
  def index
    @capacities = calculate_capacities(Date.yesterday)
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
end
