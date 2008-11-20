class ReportController < ApplicationController

  include Statistics, Graphs, ProjectsHelper
 
  def index
    # Get/Set the report date
    if params[:report_date]
      @report_date =  Date::strptime(params[:report_date])
    else
      if cookies[:report_date]
        @report_date =  Date::strptime(cookies[:report_date])
      end
    end
    @report_date = Date.today unless @report_date
          
    cookies[:report_date]=@report_date.to_s
    
    
    @projectplan = calculate_project_days(@report_date)
    firstproject = @projectplan[@projectplan.keys.first]
    @last_report_date = firstproject[:reportdate]

    @graph_wt = open_flash_chart_object(300,300,"/report/graph_worktypes")

    @graph_quint = open_flash_chart_object(500,300,"/report/graph_quintiles")

  end
   
end
