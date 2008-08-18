class ReportController < ApplicationController

  include Statistics, Graphs
 
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
    
#    @graph_wt = open_flash_chart_object(200,200,"/report/graph_worktypes")
  end
   
end
