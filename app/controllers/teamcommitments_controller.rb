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

class TeamcommitmentsController < ApplicationController
  # GET /teamcommitments
  # GET /teamcommitments.xml
  cache_sweeper :audit_sweeper
  
  include Statistics
  
  #TODO: Refactor.
  def index
    session[:original_uri] = request.request_uri
    session[:team_id] = nil  #no filtering by team
    if params[:report_date]
      @report_date =  Date::strptime(params[:report_date])
    else
      if cookies[:report_date]
        @report_date =  Date::strptime(cookies[:report_date])
      end
    end
    @report_date = Date.today unless @report_date
    @teams = Team.find(:all)
      
    cookies[:report_date]=@report_date.to_s
      
    @projects = list_current_projects(@report_date)
    @projects = @projects.sort{|a,b| a.country_id<=>b.country_id}

    #Only show for current month
    monthbegend = get_month_beg_end(@report_date)
    month_begin = monthbegend[:first_day]
    month_end = monthbegend[:last_day]

    @teamcommitments = Teamcommitment.find(:all, :conditions => ["yearmonth <= ? and yearmonth >= ?",month_end, month_begin])
 
    @outputlist = [] 
    
    @teamcommitments.each do |commitment| 
        team = Team.find_by_id(commitment[:team_id])
        teamname = team.name unless team == nil
        project = Project.find_by_id(commitment[:project_id])
        projectname = project.name unless project == nil
        output = { :classname => commitment,
                   :id => commitment.id,
                   :teamname => teamname, 
                   :yearmonth => commitment.yearmonth,
                   :projectname => projectname,
                   :days => commitment.days,
                   :status => commitment.status,
                   :project.preload? => project.worktype.project.preload? }
        @outputlist << output
    end
    @outputlist = @outputlist.sort{|a,b| a[:teamname]<=>b[:teamname]}

    session[:original_uri] = request.request_uri

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @outputlist }
    end
  end

  # GET /teamcommitments/1
  # GET /teamcommitments/1.xml
  def show
    @teamcommitment = Teamcommitment.find(params[:id])
 
    team = Team.find_by_id(@teamcommitment[:team_id])
    project = Project.find_by_id(@teamcommitment[:project_id])
    teamname = team.name unless team.nil?
    projectname = project.name unless project.nil?
    @output = { :teamname => teamname, 
                :yearmonth => @teamcommitment[:yearmonth],
                :projectname => projectname,
                :days => @teamcommitment[:days] }

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @output }
  
    end
  end

  # GET /teamcommitments/new
  # GET /teamcommitments/new.xml
  def new
    @teamcommitment = Teamcommitment.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @teamcommitment }
    end
  end

  # GET /teamcommitments/1/edit
  def edit
    @teamcommitment = Teamcommitment.find(params[:id])
    session[:original_uri] = request.request_uri
  end

  # POST /teamcommitments
  # POST /teamcommitments.xml
  def create
    @teamcommitment = Teamcommitment.new(params[:teamcommitment])

    respond_to do |format|
      @teamcommitment.status = Teamcommitment::StatusProposed 
      if @teamcommitment.save
        flash[:notice] = 'Commitment was successfully created.'
        format.html { redirect_to(session[:original_uri]) }
        format.xml  { render :xml => @teamcommitment, :status => :created, :location => @teamcommitment }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @teamcommitment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /teamcommitments/1
  # PUT /teamcommitments/1.xml
  def update
    @teamcommitment = Teamcommitment.find(params[:id])

    respond_to do |format|
      if @teamcommitment.update_attributes(params[:teamcommitment])
        flash[:notice] = 'Commitment was successfully updated.'
        format.html { redirect_to(session[:original_uri]) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @teamcommitment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /teamcommitments/1
  # DELETE /teamcommitments/1.xml
  def destroy
    @teamcommitment = Teamcommitment.find(params[:id])
    @tasks = @teamcommitment.tasks

    @teamcommitment.destroy
    @tasks.each do |task| 
      task.destroy 
    end

    respond_to do |format|
      format.html { redirect_to(teamcommitments_url) }
      format.xml  { head :ok }
    end
  end
 
  def commitment_accept
    @commitment = Teamcommitment.find(params[:id])
    return false if @commitment.status != Teamcommitment::StatusProposed 
    @commitment.status = Teamcommitment::StatusAccepted
    if @commitment.save
      @changed_commitment = @commitment.id
      set_commitment_list
      true
    else
      false
    end
  end 

  #TODO: Refactor. Code duplication.
  def set_commitment_list
    if cookies[:report_date]
     @report_date =  Date::strptime(cookies[:report_date])
    end
    @report_date = Date.today unless @report_date
    
    #Only show for current month
    monthbegend = get_month_beg_end(@report_date)
    month_begin = monthbegend[:first_day]
    month_end = monthbegend[:last_day]

    if session[:team_id] then
      team = Team.find_by_id(session[:team_id])
      commitmentlist = team.commitments(@report_date)
    else
      commitmentlist = Teamcommitment.find(:all, :conditions => ["yearmonth <= ? and yearmonth >= ?",month_end, month_begin])
    end
    @outputlist = []
    commitmentlist.each do |commitment|
        team = Team.find_by_id(commitment[:team_id])
        teamname = team.name unless team == nil
        project = Project.find_by_id(commitment[:project_id])
        projectname = project.name unless project == nil
        output = { :classname => commitment,
                   :id => commitment.id,
                   :teamname => teamname, 
                   :yearmonth => commitment.yearmonth,
                   :projectname => projectname,
                   :days => commitment.days,
                   :status => commitment.status,
                   :project.preload? => project.worktype.project.preload?  }
        @outputlist << output    
    end
     @outputlist = @outputlist.sort{|a,b| a[:teamname]<=>b[:teamname]}
  end

  def assign_tasks
    @teamcommitment = Teamcommitment.find(params[:id])
  end
end
