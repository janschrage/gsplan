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

class GraphController < ApplicationController

 include Statistics, ProjectsHelper

 def graph_usage
   date = Date::strptime(cookies[:report_date])
   @capacities = calculate_capacities(date)
   @usage = calculate_usage(date)
   chart = Gruff::Bar.new('500x350')
   chart.title = "Resource Usage"
   # group by team and use subject as the key
   capa_values = []
   usage_values = []
   free_values = []
   labels = {}
   counter = 0
   @capacities.to_a.each do |team, capa|
      if capa > 0  #only if the team has capacity this month (temporary help from other LOBs,...)
        capa_values << capa
        usage_values << @usage[team]
        free_values << [0,capa-@usage[team]].max #no negative free capacity
        labels.merge!({ counter => team })
        counter += 1
      end
    end
    chart.labels = labels
    chart.y_axis_label = "PD"
    #capacity
    chart.data("Capacity",capa_values,'#0055ff')
    #usage
    chart.data("Utilization",usage_values,'#cc0000')
    #free
    chart.data("Free Capacity",free_values,'#00cc00')
    
    chart.theme_37signals
    send_data(chart.to_blob, :disposition => 'inline', :type => 'image/png', :filename => 'team_usage.png')
  end

  def graph_worktypes
    date = Date::strptime(cookies[:report_date])
    team_id = params[:id] || '*'

    @worktype_distribution = calculate_worktype_distribution(date, team_id)
  
    chart = Gruff::Pie.new(400)
    chart.title = "Worktypes by days booked"

    @worktype_distribution.keys.each do |wt|
      wt_name = Worktype::find_by_id(wt).name
      wt_daysbooked = @worktype_distribution[wt][:daysbooked]
      chart.data("#{wt_name}",wt_daysbooked)
    end

    chart.theme_37signals   
    send_data(chart.to_blob, :disposition => 'inline', :type => 'image/png', :filename => 'wt_stats.png')
  end

  def graph_quintiles

   date = Date::strptime(cookies[:report_date]) || Date.today
   projects = calculate_project_days(date)
   teams = Team::find(:all)
   chart = Gruff::Bar.new('600x400')
   values = {}

   capacities = calculate_capacities(date) #only show teams with capa >0

   teams.each do |team|
        values[team] = [0,0,0,0,0,0,0] if capacities[team.name] > 0
   end
   chart.title = "Errors of commitment estimates"
    # group by team and use subject as the key
    chart.labels = { 0 => "grave", 1 => "0-20%", 2 => "20-40%", 3 => "40-60%", 
               4 => "60-80%", 5 =>">80%", 6 => "zombie" }

   projects.each do |project|
      quintile = project_quintile(project[1][:committed_inper],project[1][:daysbooked])
      team = Project.find_by_id(project[0]).country.team 
      values[team][quintile] += 1 if capacities[team.name] > 0
    end
  
#    ymax = 0
#    teams.each do |team|
#      ymax = [ymax,values[team].max].max
#    end
    #y_axis.set_range(0,ymax+2,5)   
  
    chart.y_axis_label = "No. commitments"
    teams.each do |team|
      chart.data(team.name,values[team]) if capacities[team.name] > 0
    end
    chart.minimum_value = 0
    chart.theme_37signals   
    send_data(chart.to_blob, :disposition => 'inline', :type => 'image/png', :filename => 'quintiles.png')
  end

  def graph_planning_delta_in_days
   date = Date::strptime(cookies[:report_date]) || Date.today
   projects = calculate_project_days(date)
   teams = Team::find(:all)
   chart = Gruff::Bar.new('600x400')
   values = {}

   chart.title = "Absolute difference execution vs. planning"
    # group by team and use subject as the key

   capacities = calculate_capacities(date) #only show teams with capa >0

   teams.each do |team|
        values[team] = 0 if capacities[team.name] > 0
   end

   projects.each do |project|
      delta = (project[1][:committed_inper] - project[1][:daysbooked]).abs
      team = Project.find_by_id(project[0]).country.team
      values[team] += delta if capacities[team.name] > 0
    end
  
    chart.y_axis_label = "Sum of Delta (PD)"

    teams.each do |team|
      chart.data(team.name,values[team]) if capacities[team.name] > 0
    end
    chart.minimum_value = 0
    chart.theme_37signals   
    send_data(chart.to_blob, :disposition => 'inline', :type => 'image/png', :filename => 'sumofdeltas.png')
  end

end
