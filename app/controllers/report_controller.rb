class ReportController < ApplicationController
  def index
    @capacities = calculate_capacities(Date.today)
    @graph = open_flash_chart_object(600,300,"/report/graph_capacity")
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
  
  def graph_capacity
   date = Date.today
   @capacities = calculate_capacities(date)
   title = Title.new("Team Capacity")
    # group by team and use subject as the key
    x_axis = XAxis.new
    values = []
    labels = []

   @capacities.to_a.each do |capa|
      values << capa[1]
      labels << capa[0]
    end
   
    x_axis.labels=labels
    bar = BarGlass.new
    bar.set_values(values)
    chart = OpenFlashChart.new
    chart.title = title
    chart.x_axis = x_axis
    chart.add_element(bar)
    render :text => chart.to_s
  end
end
