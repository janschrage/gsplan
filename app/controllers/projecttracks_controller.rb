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

require 'csv'

class ProjecttracksController < ApplicationController
  
  include ProjecttracksHelper
  
  TaskNotAssigned = "Not assigned"         #Time on cost center, ADMI etc
  TaskTotal       = "Result"               #Total for that person, ignore
  
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
  
  def import
  
    respond_to do |format|
        format.html { render :action => "import" }
        format.xml  { render :xml => @tracks }
    end
  end

  def show_import      
    @report_date = Date::strptime(cookies[:report_date])
    respond_to do |format|
        format.html { render :action => "show_import" }
        format.xml  { render :xml => @tracks }
    end
  end

  def show_conversion 
    @report_date = Date::strptime(cookies[:report_date])
    respond_to do |format|
        format.html { render :action => "show_import", :report_date => @report_date }
        format.xml  { render :xml => @tracks }
    end
  end

  def show_commit
    @report_date = Date::strptime(cookies[:report_date])
    respond_to do |format|
        format.html { render :action => "show_commit" }
        format.xml  { render :xml => @errors }
    end
  end
  
  def do_import
    @report_date = Date::strptime(params[:dump][:report_date])
    cookies[:report_date]=@report_date.to_s
    
    @parsed_file=CSV::Reader.parse(params[:dump][:file], ';')
    track={}
    @tracks=[]
    pernr=""
    name=""
    days=0.0
    @errors=0
    @parsed_file.each  do |row|
      #pt=Projecttrack.new() 
      pernr=row[0] unless row[0].nil?
      pernr[0,1]="I" if pernr[0,1]=="1"
      name=row[1] unless row[1].nil?
      task=row[2]
      if task == TaskNotAssigned
        days=row[3].gsub(',','.').to_f unless row[3].nil?
      else
        days=row[4].gsub(',','.').to_f unless row[4].nil?
      end  
      if task != TaskTotal and days > 0
        #Check for errors
        eeok=true
        prok=true
        eeok = false unless Employee.find_by_pernr(pernr)
        prok = false unless CproProject.find_by_cpro_name(task)
        @errors = @errors + 1 unless prok and eeok
        track={ :pernr => pernr, :name => name, :task => task , :days => days, :eeok => eeok, :prok => prok}
        @tracks << track
      end
    end
    
    respond_to do |format|
        format.html { render :action => "show_import" }
        format.xml  { render :xml => @tracks }
    end  
  end
  
  def do_conversion
    #Do the conversion to team data here
    @tracks=flash[:tracks]
    @teamtracks={}
    @report_date = Date::strptime(cookies[:report_date])
    @errors = []
    @tracks.each do |track|
      ee_id=Employee.find_by_pernr(track[:pernr]).id
      teamlink=Teammember.find(:first, :conditions => ["employee_id = ? and begda <= ? and endda >= ?", ee_id, @report_date,@report_date])
      if teamlink then 
        team_id = teamlink.team_id      
        project_id=CproProject.find_by_cpro_name(track[:task]).project_id
        key = team_id.to_s+"x"+project_id.to_s
        prevtrack=@teamtracks[key]
        if prevtrack then
          prevtrack[:days] = prevtrack[:days] + track[:days]
          @teamtracks[key]=prevtrack
        else 
          @teamtracks[key]={:team_id => team_id, :project_id => project_id, :days => track[:days]}
        end
      else
        @errors << "No team found in reporting period: Employee #{track[:pernr]}"
      end
    end
    @errors = @errors.uniq
    
    respond_to do |format|
        format.html { render :action => "show_conversion" }
        format.xml  { render :xml => @teamtracks }
    end 
  end
  
  def do_commit
    #commit upload to db
    @report_date = Date::strptime(cookies[:report_date])
    @today = Date.today
    @errors=[]
    @key=""
    @tracks=flash[:tracks]
    @projects=[]
    begin
      Projecttrack.transaction do
        @tracks.keys.each do |key|
          @key=key
          @pt = Projecttrack.new(:team_id => @tracks[key][:team_id], :project_id => @tracks[key][:project_id], :yearmonth => @report_date, :reportdate => @today, :daysbooked => @tracks[key][:days])
          if !@pt.valid? then
            @errors << "Error for #{team_by_id(@tracks[@key][:team_id])} / #{project_by_id(@tracks[@key][:project_id])}"
            @pt.errors.each_full {|msg| @errors<<msg}
            #raise "Transaction failure"
          end
          @projects << @pt if @pt.valid?
        end
        raise "Transaction failure" unless @errors.empty?
        @projects.each do |project|
          project.save
        end
      end
    rescue
       
       @errors << "Transaction aborted."
    end
 
    respond_to do |format|
        flash[:notice] = 'Data was successfully committed.' if @errors.empty?
        format.html { render :action => "show_commit" }
        format.xml  { render :xml => @errors }
    end 
  end
end
