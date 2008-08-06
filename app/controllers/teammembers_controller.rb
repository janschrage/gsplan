class TeammembersController < ApplicationController
  # GET /teammembers
  # GET /teammembers.xml
  layout "teammembers"
  
  def index
    
    @teammembers = Teammember.find(:all)
 
    @outputlist = []
    
    @teammembers.each do |teammember| 
      if teammember.endda >= Date.today
        employeename = Employee.find_by_id(teammember[:employee_id]).name
        teamname = Team.find_by_id(teammember[:team_id]).name
      
        output = { :classname => teammember,
                   :employeename => employeename, 
                   :planbeg => teammember.begda,
                   :planend => teammember.endda,
                   :teamname => teamname}
        @outputlist << output
      end
    end
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @outputlist }
    end
  end
  
  def new
    @teammember = Teammember.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @teammember }
    end
  end
  
  def show
    teammember = Teammember.find(params[:id])
 
    employeename = Employee.find_by_id(teammember[:employee_id]).name
    teamname = Team.find_by_id(teammember[:team_id]).name
      
    @output = {:classname => teammember,
               :employeename => employeename, 
               :planbeg => teammember.begda,
               :planend => teammember.endda,
               :teamname => teamname}

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @output }
  
    end
  end

  def edit
    @teammember = Teammember.find(params[:id])
  end

  def create
    @teammember = Teammember.new(params[:teammember])

    respond_to do |format|
      if @teammember.save
        flash[:notice] = 'Team member was successfully created.'
        format.html { redirect_to(@teammember) }
        format.xml  { render :xml => @teammember, :status => :created, :location => @teammember }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @teammember.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def update
    @teammember = Teammember.find(params[:id])

    respond_to do |format|
      if @teammember.update_attributes(params[:teammember])
        flash[:notice] = 'Commitment was successfully updated.'
        format.html { redirect_to(@teammember) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @teammember.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @teammember = Teammember.find(params[:id])
    @teammember.destroy

    respond_to do |format|
      format.html { redirect_to(teammembers_url) }
      format.xml  { head :ok }
    end
  end
end

