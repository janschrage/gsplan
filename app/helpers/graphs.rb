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

module Graphs
  
  def graph_capacity
   date = Date::strptime(cookies[:report_date]) || Date.today
   @capacities = calculate_capacities(date)
   title = Title.new("Team Capacity")
    # group by team and use subject as the key
    x_axis = XAxis.new
    y_axis = YAxis.new
    values = []
    labels = []

   @capacities.to_a.each do |capa|
      values << capa[1]
      labels << capa[0]
    end
    
    ymax = values.max
    y_axis.set_range(0,ymax+5,10)   
  
    x_axis.labels=labels
    bar = BarGlass.new
    bar.set_values(values)
    chart = OpenFlashChart.new
    chart.title = title
    chart.x_axis = x_axis
    chart.y_axis = y_axis
    chart.add_element(bar)
    render :text => chart.to_s
  end
  
 def graph_usage
   date = Date::strptime(cookies[:report_date])
   @capacities = calculate_capacities(date)
   @usage = calculate_usage(date)
   title = Title.new("Resource Usage")
    # group by team and use subject as the key
    x_axis = XAxis.new
    y_axis = YAxis.new
    capa_values = []
    usage_values = []
    free_values = []
    labels = []

   @capacities.to_a.each do |team, capa|
      if capa > 0  #only if the team has capacity this month (temporary help from other LOBs,...)
        capa_values << capa
        usage_values << @usage[team]
        free_values << capa-@usage[team]
        labels << team
      end
    end
    ymax = capa_values.max
    if free_values.min < 0 then
      ymin = free_values.min - 2
    else
      ymin = 0
    end
    y_axis.set_range(ymin,ymax+5,10)   
    x_axis.labels=labels
    #capacity
    bar1 = BarGlass.new
    bar1.colour = "#00ffff"
    bar1.set_values(capa_values)
    bar1.set_key("Capacity", 3)
    #usage
    bar2 = BarGlass.new
    bar2.colour = "#ff0000"
    bar2.set_values(usage_values)
    bar2.set_key("Utilization", 3)
    #free
    bar3 = BarGlass.new
    bar3.colour = "#00ff00"
    bar3.set_values(free_values)
    bar3.set_key("Free Capacity", 3)

    chart = OpenFlashChart.new
    chart.title = title
    chart.x_axis = x_axis
    chart.y_axis = y_axis
    chart.add_element(bar1)
    chart.add_element(bar2)
    chart.add_element(bar3)
    render :text => chart.to_s
  end

  def graph_worktypes
    date = Date::strptime(cookies[:report_date])
    @worktype_distribution = calculate_worktype_distribution(date)
  
    pie = Gruff::Pie.new(300)
    pie.title = "Worktypes by days booked"

    @worktype_distribution.keys.each do |wt|
      wt_name = Worktype::find_by_id(wt).name
      wt_daysbooked = @worktype_distribution[wt][:daysbooked]
      pie.data("#{wt_name}",wt_daysbooked)
    end
    #pie.colours = ["#d01f3c", "#356aa0", "#C79810", "#aaff00", "#ffaa00", "#00aaff", "#00ffaa"]

    
    send_data(pie.to_blob, :disposition => 'inline', :type => 'image/png', :filename => 'wt_stats.png')
  end

  def graph_quintiles
   date = Date::strptime(cookies[:report_date]) || Date.today
   projects = calculate_project_days(date)
   teams = Team::find(:all)
   chart = Gruff::Bar.new(500)
   bar = {}
   values = {}
   key = {}
   colours = ["#459a89", "#9a89f9", "#115599", "#782836", "#19affe", "#ffbb30", "#00fae2","#2345aa"]
   count = 0
   teams.each do |team|
        count += 1
        bar[team] = BarGlass.new
        bar[team].set_key(team.name,3)
        bar[team].colour = colours[count]
        values[team] = [0,0,0,0,0,0,0]
   end
   chart.title = "Errors of commitment estimates"
    # group by team and use subject as the key
#    x_axis = XAxis.new
#    y_axis = YAxis.new
    chart.labels = { 0 => "grave", 1 => "0-20%", 2 => "20-40%", 3 => "40-60%", 
               4 => "60-80%", 5 =>">80%", 6 => "zombie" }

   projects.each do |project|
      quintile = project_quintile(project[1][:committed_inper],project[1][:daysbooked])
      team = Project.find_by_id(project[0]).country.team
      values[team][quintile] += 1
    end
  
    ymax = 0
    teams.each do |team|
      ymax = [ymax,values[team].max].max
    end
    #y_axis.set_range(0,ymax+2,5)   
  
    #x_axis.labels=labels
    teams.each do |team|
      chart.data(team.name,values[team])
    end
    send_data(chart.to_blob, :disposition => 'inline', :type => 'image/png', :filename => 'quintiles.png')
  end

end

