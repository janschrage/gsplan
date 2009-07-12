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

class ProjectsController < ApplicationController
  cache_sweeper :audit_sweeper

  include Statistics, ProjectsHelper
  
  def index
    session[:original_uri] = request.request_uri
 
    @projects = Project.find(:all)

    @outputlist = []
    
    if @projects != nil
      @projects.each do |project| 
       countryname = Country.find_by_id(project[:country_id]).name if project.country 
       employeename = Employee.find_by_id(project[:employee_id]).name if project.employee
       worktypename = Worktype.find_by_id(project[:worktype_id]).name if project.worktype
      
       status = project.status
      
       output = { :classname => project,
                  :countryname => countryname, 
                  :employeename => employeename, 
                  :worktypename => worktypename, 
                  :planbeg => project.planbeg,
                  :planend => project.planend,
                  :name => project.name,
                  :planeffort => project.planeffort,
                  :status => status}
        @outputlist << output
      end
    end
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @outputlist }
    end
  end
  
  def new
    @project = Project.new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @project }
    end
  end
  
  def show
    @project = Project.find(params[:id])
 
      countryname = Country.find_by_id(@project[:country_id]).name if @project.country
      employeename = Employee.find_by_id(@project[:employee_id]).name if @project.employee
      worktypename = Worktype.find_by_id(@project[:worktype_id]).name if @project.worktype
      status = project_status_text(@project.status)
            
      @output = { :classname => @project,
                 :countryname => countryname, 
                 :employeename => employeename, 
                 :worktypename => worktypename, 
                 :planbeg => @project.planbeg,
                 :planend => @project.planend,
                 :name => @project.name,
                 :status => status,
                 :planeffort => @project.planeffort}

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @output }
  
    end
  end

  def edit
    session[:original_uri] = request.request_uri
    @project = Project.find(params[:id])
  end

  def create
    @project = Project.new(params[:project])

    respond_to do |format|
      @project.status = Project::StatusProposed;  #Project is "proposed" on creation
      if @project.save
        flash[:notice] = 'Project was successfully created.'
        format.html { redirect_to(session[:original_uri]) }
        format.xml  { render :xml => @project, :status => :created, :location => @project }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @project.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def update
    @project = Project.find(params[:id])

    respond_to do |format|
      if @project.update_attributes(params[:project])
        flash[:notice] = 'Project was successfully updated.'
        format.html { redirect_to(session[:original_uri]) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @project.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @project = Project.find(params[:id])
    @project.destroy

    @teamcommitments = Teamcommitment.find_all_by_project_id(params[:id])
    if @teamcommitments != nil
      @teamcommitments.each do |@teamcommitment|
       @teamcommitment.destroy
     end
    end
    respond_to do |format|
      format.html { redirect_to(projects_url) }
      format.xml  { head :ok }
    end
  end
  
  def prj_accept
    @project = Project.find(params[:id])
    return false if @project.status != Project::StatusProposed 
    @project.status = Project::StatusOpen
    @changed_project = @project.id
    if @project.save
      set_project_plan  #inside and twice, otherwise not updated with saved data
      true
    else
      set_project_plan  #inside and twice, otherwise not updated with saved data
      false
    end
  end

  def prj_reject
    @project = Project.find(params[:id])
    return false if @project.status != Project::StatusProposed 
    @project.status = Project::StatusRejected
    @changed_project = @project.id
    if @project.save
      set_project_plan  #inside and twice, otherwise not updated with saved data
      true
    else
      set_project_plan  #inside and twice, otherwise not updated with saved data
      false
    end
  end

  def prj_start
    @project = Project.find(params[:id])
    @changed_project = @project.id
    if @project.status == Project::StatusProposed or @project.status == Project::StatusClosed or @project.status == Project::StatusPilot
      set_project_plan  #inside and twice, otherwise not updated with saved data
      @startcolor = "#ff0000"
      return false
    end
    @project.status = Project::StatusInProcess
    if @project.save
      set_project_plan  #inside and twice, otherwise not updated with saved data
      @startcolor = "#ffff99"
      true
    else
      set_project_plan  #inside and twice, otherwise not updated with saved data
      false
    end
  end

  def prj_pilot
    @project = Project.find(params[:id])
    @changed_project = @project.id
    if @project.status == Project::StatusProposed or @project.status == Project::StatusClosed
      set_project_plan  #inside and twice, otherwise not updated with saved data
      @startcolor = "#ff0000"
      return false
    end   
    @project.status = Project::StatusPilot
    if @project.save
      set_project_plan  #inside and twice, otherwise not updated with saved data
      @startcolor = "#ffff99"
      true
    else
      set_project_plan  #inside and twice, otherwise not updated with saved data
      @startcolor = "#ff0000"
      false
    end
  end
  
  def prj_close
    @project = Project.find(params[:id])
    return false if @project.status == Project::StatusProposed 
    @project.status = Project::StatusClosed
    @changed_project = @project.id
    if @project.save
      set_project_plan  #inside and twice, otherwise not updated with saved data
      @startcolor = "#ffff99"
      true
    else
      set_project_plan  #inside and twice, otherwise not updated with saved data
      @startcolor = "#ff0000"
      false
    end
  end

  def set_project_plan
   if cookies[:report_date]
     @report_date =  Date::strptime(cookies[:report_date])
    end
    @report_date = Date.today unless @report_date

    @missingdays = {}
    if session[:team_id] then
      @projectplan = get_projects_for_team_and_month(@report_date)
    else
      @projectplan = calculate_project_days(@report_date)
    end
    @projectplan.keys.each do |project_id|
      @missingdays[project_id] = Project.find_by_id(project_id).planeffort - @projectplan[project_id][:committed_total]
    end
    @projectplan = @projectplan.sort{|a,b| a[1][:country]<=>b[1][:country]}
  end

  def assign_reviewers
    @project = Project.find(params[:id])
  end
end
