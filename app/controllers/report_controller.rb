class ReportController < ApplicationController

  include Statistics, Graphs
 
  def index
    @report_date = Date.today
    @capacities = calculate_capacities(Date.today)
    @graph = open_flash_chart_object(600,300,"/report/graph_capacity")
  end
   
end
