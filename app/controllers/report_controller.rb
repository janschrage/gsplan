class ReportController < ApplicationController

  include Statistics, Graphs
 
  def index
    @capacities = calculate_capacities(Date.today)
    @graph = open_flash_chart_object(600,300,"/report/graph_capacity")
  end
   
end
