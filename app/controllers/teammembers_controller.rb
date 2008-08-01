class TeammembersController < ApplicationController
  # GET /teammembers
  # GET /teammembers.xml
  layout "teammembers"
  
  active_scaffold :teammember do |config|
    config.label = "Current Team Members"
    config.list.columns.exclude :employee_id, :team_id
    config.columns = [:teamname, :eename, :begda, :endda]
    list.sorting = {:teamname => 'ASC'}
    # In the List view, we'll combine two fields into one by hiding two "real" fields and adding one "virtual" field.
   
    columns[:eename].label = 'Employee'
    columns[:teamname].label = 'Team'
    columns[:begda].label = 'Begin Date'
    columns[:endda].label = 'End Date'
  end

  def conditions_for_collection
    # Current team members only
    ['endda >= (?)', Date.today]
  end
end
