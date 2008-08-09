class CproProjectsController < ApplicationController
  # GET /cpro_projects
  # GET /cpro_projects.xml
  def index
    @cpro_projects = CproProject.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @cpro_projects }
    end
  end

  # GET /cpro_projects/1
  # GET /cpro_projects/1.xml
  def show
    @cpro_project = CproProject.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @cpro_project }
    end
  end

  # GET /cpro_projects/new
  # GET /cpro_projects/new.xml
  def new
    @cpro_project = CproProject.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @cpro_project }
    end
  end

  # GET /cpro_projects/1/edit
  def edit
    @cpro_project = CproProject.find(params[:id])
  end

  # POST /cpro_projects
  # POST /cpro_projects.xml
  def create
    @cpro_project = CproProject.new(params[:cpro_project])

    respond_to do |format|
      if @cpro_project.save
        flash[:notice] = 'CproProject was successfully created.'
        format.html { redirect_to(@cpro_project) }
        format.xml  { render :xml => @cpro_project, :status => :created, :location => @cpro_project }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @cpro_project.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /cpro_projects/1
  # PUT /cpro_projects/1.xml
  def update
    @cpro_project = CproProject.find(params[:id])

    respond_to do |format|
      if @cpro_project.update_attributes(params[:cpro_project])
        flash[:notice] = 'CproProject was successfully updated.'
        format.html { redirect_to(@cpro_project) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @cpro_project.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /cpro_projects/1
  # DELETE /cpro_projects/1.xml
  def destroy
    @cpro_project = CproProject.find(params[:id])
    @cpro_project.destroy

    respond_to do |format|
      format.html { redirect_to(cpro_projects_url) }
      format.xml  { head :ok }
    end
  end
end
