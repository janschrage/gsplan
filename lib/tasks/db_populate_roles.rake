namespace :db do
  desc "Populates the database with default roles and rights."
  task :populate_roles => :environment do

    #Admin
    role_admin  = Role.create :name => "Admin"
    right_all = Right.create :name => "all", :controller => "*", :action => "*"
    role_admin.rights << right_all
    role_admin.save!
    
    #Team Lead
    role_tl = Role.create :name => "Teamlead"
    right_list_prj = Right.create :name => "list_projects", :controller => "projects", :action => "index"
    right_list_rep = Right.create :name => "list_report", :controller => "report", :action => "index"
    right_list_tc = Right.create :name => "list_teamcommitments", :controller => "teamcommitments", :action => "index"
    right_graph_us = Right.create :name => "graph_usage", :controller => "graph", :action => "graph_usage"
    right_graph_wt = Right.create :name => "graph_worktypes", :controller => "graph", :action => "graph_worktypes"
    right_graph_qt = Right.create :name => "graph_quintiles", :controller => "graph", :action => "graph_quintiles"
    right_graph_delta = Right.create :name => "graph_delta_pd", :controller => "graph", :action => "graph_planning_delta_in_days"
    right_logout = Right.create :name => "logout", :controller => "admin", :action => "logout"
    right_change_pw = Right.create :name => "change_password", :controller => "users", :action =>"change_password"
    right_update_user = Right.create :name => "update_user", :controller => "users", :action =>"update" #Needed for pw change
    right_new_project = Right.create :name => "new_project", :controller => "projects", :action =>"new"
    right_create_project = Right.create :name => "create_project", :controller => "projects", :action =>"create"
    right_start_project = Right.create :name => "close_project", :controller => "projects", :action =>"prj_start"
    right_pilot_project = Right.create :name => "pilot_project", :controller => "projects", :action =>"prj_pilot"
    right_close_project = Right.create :name => "close_project", :controller => "projects", :action =>"prj_close"
    right_myteam = Right.create :name => "myteam", :controller => "myteam", :action => "index"
    right_create_commitment = Right.create :name => "create_commitment", :controller => "teamcommitments", :action => "create"
    right_list_current_reviews = Right.create :name => "reviews_list_current", :controller => "reviews", :action => "current_projects"
    right_assign_tasks = Right.create :name => "teamcommitments_assign_tasks", :controller => "teamcommitments", :action => "assign_tasks"
    role_tl.rights = [right_list_prj, right_list_rep, right_list_tc, right_graph_us, right_graph_wt, right_logout, right_change_pw, right_update_user, right_new_project, right_create_project, right_myteam, right_pilot_project, right_close_project, right_start_project, right_create_commitment, right_list_current_reviews, right_graph_delta, right_assign_tasks ]
    role_tl.save!

    #Team member
    role_tm = Role.create :name => "Teammember" 
    role_tm.rights = [right_graph_wt,right_graph_qt,right_graph_delta,right_logout,right_change_pw,right_update_user,right_myteam] 
    role_tm.save!

    #Reviewer (assumed to be also team member)
    role_rev = Role.create :name => "Reviewer"
    right_new_review = Right.create :name => "new_review", :controller => "reviews", :action =>"new"
    right_show_review = Right.create :name => "show_review", :controller => "reviews", :action =>"show"
    right_create_review = Right.create :name => "create_review", :controller => "reviews", :action => "create"
    right_review_project = Right.create :name => "review_project", :controller => "reviews", :action => "review_project"
    role_rev.rights = [right_list_current_reviews, right_create_review,right_show_review,right_new_review]
    role_rev.save!

    
  end
end
    