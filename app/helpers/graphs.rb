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
  
    pie = Pie.new
    title = Title.new("Worktypes by days booked")
    pie.start_angle = 35
    pie.animate = true
    pie.tooltip = '#val# of #total#<br>#percent# of 100%'
    pievalues = []

    @worktype_distribution.keys.each do |wt|
      wt_name = Worktype::find_by_id(wt).name
      wt_daysbooked = @worktype_distribution[wt][:daysbooked]
      pievalues << PieValue.new(wt_daysbooked,"#{wt_name}")
    end
    pie.values = pievalues.to_a
    pie.colours = ["#d01f3c", "#356aa0", "#C79810", "#aaff00", "#ffaa00", "#00aaff", "#00ffaa"]

    chart = OpenFlashChart.new
    chart.title = title
    chart.add_element(pie)

    chart.x_axis = nil

    render :text => chart.to_s

  end

  def graph_quintiles
   date = Date::strptime(cookies[:report_date]) || Date.today
   projects = calculate_project_days(date)
   teams = Team::find(:all)
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
   title = Title.new("Quality of commitment estimates")
    # group by team and use subject as the key
    x_axis = XAxis.new
    y_axis = YAxis.new
    labels = ["grave","0-20%","20-40%","40-60%","60-80%",">80%","zombie"]

   projects.each do |project|
      quintile = project_quintile(project[1][:committed_inper],project[1][:daysbooked])
      team = Project.find_by_id(project[0]).country.team
      values[team][quintile] += 1
    end
  
    ymax = 0
    teams.each do |team|
      ymax = [ymax,values[team].max].max
    end
    y_axis.set_range(0,ymax+2,5)   
  
    x_axis.labels=labels
    chart = OpenFlashChart.new
    chart.title = title
    chart.x_axis = x_axis
    chart.y_axis = y_axis
    teams.each do |team|
      bar[team].set_values(values[team])
      chart.add_element(bar[team])
    end
    render :text => chart.to_s
  end

end

