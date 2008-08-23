class AddRolesRightsData < ActiveRecord::Migration
  def self.up
    down
    
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
    right_graph_us = Right.create :name => "graph_usage", :controller => "report", :action => "graph_usage"
    right_graph_wt = Right.create :name => "graph_worktypes", :controller => "report", :action => "graph_worktypes"
    right_logout = Right.create :name => "logout", :controller => "admin", :action => "logout"
    right_change_pw = Right.create :name => "change_password", :controller => "users", :action =>"change_password"
    right_update_user = Right.create :name => "update_user", :controller => "users", :action =>"update" #Needed for pw change
    role_tl.rights = [right_list_prj, right_list_rep, right_list_tc, right_graph_us, right_graph_wt, right_logout, right_change_pw, right_update_user]
    role_tl.save!
    
  end

  def self.down
    Role.delete(:all)
    Right.delete(:all)
  end
end
