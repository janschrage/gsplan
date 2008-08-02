class TeamcommitmentsController < ApplicationController
  # GET /teamcommitments
  # GET /teamcommitments.xml
  
  include Statistics, Graphs
    
  def index
    @report_date = Date.today
    @teamusage = calculate_usage(@report_date)
    @capacities = calculate_capacities(@report_date)
    @graph = open_flash_chart_object(600,300,"/report/graph_usage")
 
    @freecapacity = {}
    @capacities.to_a.each do |team, capacity|
      @freecapacity[team]=capacity - @teamusage[team]
    end
    @teamcommitments = Teamcommitment.find(:all)
 
    @outputlist = []
    
    @teamcommitments.each do |@commitment| 
      teamname = Team.find_by_id(@commitment[:team_id]).name
      projectname = Project.find_by_id(@commitment[:project_id]).name
      output = { :classname => @commitment,
                 :teamname => teamname, 
                 :yearmonth => @commitment.yearmonth,
                 :projectname => projectname,
                 :days => @commitment.days }
      @outputlist << output
    end
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @outputlist }
    end
  end

  # GET /teamcommitments/1
  # GET /teamcommitments/1.xml
  def show
    @teamcommitment = Teamcommitment.find(params[:id])
 
    teamname = Team.find_by_id(@teamcommitment[:team_id]).name
    projectname = Project.find_by_id(@teamcommitment[:project_id]).name
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
  end

  # POST /teamcommitments
  # POST /teamcommitments.xml
  def create
    @teamcommitment = Teamcommitment.new(params[:teamcommitment])

    respond_to do |format|
      if @teamcommitment.save
        flash[:notice] = 'Teamcommitment was successfully created.'
        format.html { redirect_to(@teamcommitment) }
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
        flash[:notice] = 'Teamcommitment was successfully updated.'
        format.html { redirect_to(@teamcommitment) }
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
    @teamcommitment.destroy

    respond_to do |format|
      format.html { redirect_to(teamcommitments_url) }
      format.xml  { head :ok }
    end
  end
  
 
end
