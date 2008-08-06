class ProjectsController < ApplicationController
  layout "projects"
  
  include Statistics
  
  def index
    @projectplan = calculate_project_days(nil)
        
    @missingdays = {}
    
    @projects = Project.find(:all)
 
    @outputlist = []
    
    @projects.each do |project| 
      countryname = Country.find_by_id(project[:country_id]).name
      employeename = Employee.find_by_id(project[:employee_id]).name
      worktypename = Worktype.find_by_id(project[:worktype_id]).name
      
      committed = @projectplan[project.name]
      missing = project.planeffort - committed
      
      output = { :classname => project,
                 :countryname => countryname, 
                 :employeename => employeename, 
                 :worktypename => worktypename, 
                 :planbeg => project.planbeg,
                 :planend => project.planend,
                 :name => project.name,
                 :planeffort => project.planeffort,
                 :committed => committed,
                 :missing => missing}
      @outputlist << output
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
 
      countryname = Country.find_by_id(@project[:country_id]).name
      employeename = Employee.find_by_id(@project[:employee_id]).name
      worktypename = Worktype.find_by_id(@project[:worktype_id]).name
            
      @output = { :classname => @project,
                 :countryname => countryname, 
                 :employeename => employeename, 
                 :worktypename => worktypename, 
                 :planbeg => @project.planbeg,
                 :planend => @project.planend,
                 :name => @project.name,
                 :planeffort => @project.planeffort}

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @output }
  
    end
  end

  def edit
    @project = Project.find(params[:id])
  end

  def create
    @project = Project.new(params[:project])

    respond_to do |format|
      if @project.save
        flash[:notice] = 'Project was successfully created.'
        format.html { redirect_to(@project) }
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
        flash[:notice] = 'Commitment was successfully updated.'
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

    respond_to do |format|
      format.html { redirect_to(projects_url) }
      format.xml  { head :ok }
    end
  end
end
