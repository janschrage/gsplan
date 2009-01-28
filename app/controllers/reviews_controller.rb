class ReviewsController < ApplicationController

  cache_sweeper :audit_sweeper

  # GET /reviews
  # GET /reviews.xml
  include TeamcommitmentsHelper

  def index
    if params[:id].nil?
      @reviews = Review.find(:all)
      session[:original_uri] = "/reviews"
    else
      @reviews = Review.find(:all,:conditions => ["project_id = ?",params[:id]])
      @reviews ||= []
      session[:original_uri] = "/reviews/for_project"
    end
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @reviews }
    end
  end
  
  def current_projects
    @projects = project_list_current()
    session[:original_uri] = "/reviews/current_projects"
    @projects.delete_if { |project| project.worktype.needs_review.nil? } 

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @projects }
    end
  end
  
  # GET /reviews/1
  # GET /reviews/1.xml
  def show
    @review = Review.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @review }
    end
  end

  def review_project
    project_id = params[:id]
    flash[:project_id] = project_id
    redirect_to(:action => :new)
  end

  # GET /reviews/new
  # GET /reviews/new.xml
  def new
    @review = Review.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @review }
    end
  end

  # GET /reviews/1/edit
  def edit
    @review = Review.find(params[:id])
  end

  # POST /reviews
  # POST /reviews.xml
  def create
    @review = Review.new(params[:review])
    @review.user_id=session[:user_id]
    respond_to do |format|
      if @review.save
        flash[:notice] = 'Review was successfully created.'
        format.html { redirect_to(@review) }
        format.xml  { render :xml => @review, :status => :created, :location => @review }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @review.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /reviews/1
  # PUT /reviews/1.xml
  def update
    @review = Review.find(params[:id])

    respond_to do |format|
      if @review.update_attributes(params[:review])
        flash[:notice] = 'Review was successfully updated.'
        format.html { redirect_to(@review) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @review.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /reviews/1
  # DELETE /reviews/1.xml
  def destroy
    @review = Review.find(params[:id])
    @review.destroy

    respond_to do |format|
      format.html { redirect_to(reviews_url) }
      format.xml  { head :ok }
    end
  end
end
