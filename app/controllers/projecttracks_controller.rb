class ProjecttracksController < ApplicationController
  # GET /projecttracks
  # GET /projecttracks.xml
  def index
    @projecttracks = Projecttrack.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @projecttracks }
    end
  end

  # GET /projecttracks/1
  # GET /projecttracks/1.xml
  def show
    @projecttrack = Projecttrack.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @projecttrack }
    end
  end

  # GET /projecttracks/new
  # GET /projecttracks/new.xml
  def new
    @projecttrack = Projecttrack.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @projecttrack }
    end
  end

  # GET /projecttracks/1/edit
  def edit
    @projecttrack = Projecttrack.find(params[:id])
  end

  # POST /projecttracks
  # POST /projecttracks.xml
  def create
    @projecttrack = Projecttrack.new(params[:projecttrack])

    respond_to do |format|
      if @projecttrack.save
        flash[:notice] = 'Projecttrack was successfully created.'
        format.html { redirect_to(@projecttrack) }
        format.xml  { render :xml => @projecttrack, :status => :created, :location => @projecttrack }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @projecttrack.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /projecttracks/1
  # PUT /projecttracks/1.xml
  def update
    @projecttrack = Projecttrack.find(params[:id])

    respond_to do |format|
      if @projecttrack.update_attributes(params[:projecttrack])
        flash[:notice] = 'Projecttrack was successfully updated.'
        format.html { redirect_to(@projecttrack) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @projecttrack.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /projecttracks/1
  # DELETE /projecttracks/1.xml
  def destroy
    @projecttrack = Projecttrack.find(params[:id])
    @projecttrack.destroy

    respond_to do |format|
      format.html { redirect_to(projecttracks_url) }
      format.xml  { head :ok }
    end
  end
end
