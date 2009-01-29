class ProjectareasController < ApplicationController
  # GET /projectareas
  # GET /projectareas.xml
  def index
    @projectareas = Projectarea.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @projectareas }
    end
  end

  # GET /projectareas/1
  # GET /projectareas/1.xml
  def show
    @projectarea = Projectarea.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @projectarea }
    end
  end

  # GET /projectareas/new
  # GET /projectareas/new.xml
  def new
    @projectarea = Projectarea.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @projectarea }
    end
  end

  # GET /projectareas/1/edit
  def edit
    @projectarea = Projectarea.find(params[:id])
  end

  # POST /projectareas
  # POST /projectareas.xml
  def create
    @projectarea = Projectarea.new(params[:projectarea])

    respond_to do |format|
      if @projectarea.save
        flash[:notice] = 'Projectarea was successfully created.'
        format.html { redirect_to(@projectarea) }
        format.xml  { render :xml => @projectarea, :status => :created, :location => @projectarea }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @projectarea.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /projectareas/1
  # PUT /projectareas/1.xml
  def update
    @projectarea = Projectarea.find(params[:id])

    respond_to do |format|
      if @projectarea.update_attributes(params[:projectarea])
        flash[:notice] = 'Projectarea was successfully updated.'
        format.html { redirect_to(@projectarea) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @projectarea.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /projectareas/1
  # DELETE /projectareas/1.xml
  def destroy
    @projectarea = Projectarea.find(params[:id])
    @projectarea.destroy

    respond_to do |format|
      format.html { redirect_to(projectareas_url) }
      format.xml  { head :ok }
    end
  end
end
