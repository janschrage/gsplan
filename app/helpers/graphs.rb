module Graphs
  
  def graph_capacity
   date = Date.today
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
   date = Date.today
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
      capa_values << capa
      usage_values << @usage[team]
      free_values << capa-@usage[team]
      labels << team
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
end