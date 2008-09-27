class MyteamController < ApplicationController

  include Statistics, Graphs

  def index
    # filter by team
    team_id = User.find_by_id(session[:user_id]).team_id
    session[:team_id] = team_id  

    if params[:report_date]
      @report_date =  Date::strptime(params[:report_date])
    else
      if cookies[:report_date]
        @report_date =  Date::strptime(cookies[:report_date])
      end
    end
    @report_date = Date.today unless @report_date
    cookies[:report_date]=@report_date.to_s

    @projectplan = get_projects_for_team_and_month(@report_date)
    commitments = get_commitments_for_team_and_month(@report_date)

    session[:original_uri] = request.request_uri

    @missingdays = {}
    @projectplan.keys.each do |project_id|
      @missingdays[project_id] = Project.find_by_id(project_id).planeffort - @projectplan[project_id][:committed_total]
    end
    @projectplan = @projectplan.sort{|a,b| a[1][:country]<=>b[1][:country]}

    @outputlist = []
    commitments.each do |commitment| 
        team = Team.find_by_id(commitment.team_id)
        teamname = team.name unless team == nil
        project = Project.find_by_id(commitment.project_id)
        projectname = project.name unless project == nil
        output = { :classname => commitment,
                   :teamname => teamname, 
                   :yearmonth => commitment.yearmonth,
                   :projectname => projectname,
                   :days => commitment.days }
        @outputlist << output
    end
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => [@projects,@outputlist] }
    end
  end
end
