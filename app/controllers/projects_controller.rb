class ProjectsController < ApplicationController
  
  include Statistics
  
  def index
     
    @projects = Project.find(:all)

    @outputlist = []
    
    if @projects != nil
      @projects.each do |project| 
       countryname = Country.find_by_id(project[:country_id]).name
       employeename = Employee.find_by_id(project[:employee_id]).name
       worktypename = Worktype.find_by_id(project[:worktype_id]).name
      
       #committed = @projectplan[project.id][:committed_total]
       #missing = project.planeffort - committed
       #status = project.project_status_text(project.status)
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
    session[:original_uri] = "/projects"
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @project }
    end
  end
  
  def show
    @project = Project.find(params[:id])
 
      countryname = Country.find_by_id(@project[:country_id]).name
      employeename = Employee.find_by_id(@project[:employee_id]).name
      worktypename = Worktype.find_by_id(@project[:worktype_id]).name
      status = @project.project_status_text(@project.status)
            
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
        format.html { redirect_to(@project) }
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
  
  def prj_start
    @project = Project.find(params[:id])
    @project.status = Project::StatusInProcess
    if @project.save
      set_project_plan
      true
    else
      false
    end
  end

  def prj_pilot
    @project = Project.find(params[:id])
    @project.status = Project::StatusPilot
    if @project.save
      set_project_plan
      true
    else
      false
    end
  end
  
  def prj_close
    @project = Project.find(params[:id])
    @project.status = Project::StatusClosed
    if @project.save
      set_project_plan
      true
    else
      false
    end
  end

  def set_project_plan
   if cookies[:report_date]
     @report_date =  Date::strptime(cookies[:report_date])
    end
    @report_date = Date.today unless @report_date

    @missingdays = {}
    @projectplan = calculate_project_days(@report_date)
    @projectplan.keys.each do |project_id|
      @missingdays[project_id] = Project.find_by_id(project_id).planeffort - @projectplan[project_id][:committed_total]
    end
    @projectplan = @projectplan.sort{|a,b| a[1][:country]<=>b[1][:country]}
  end

end
