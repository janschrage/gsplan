class TeammembersController < ApplicationController
  # GET /teammembers
  # GET /teammembers.xml
  layout "teammembers"
  
  active_scaffold :teammember do |config|
    config.label = "Current Team Members"
    config.list.columns = [:teamname, :eename, :begda, :endda]   
    config.columns = [:teamname, :eename, :begda, :endda]
    list.sorting = {:teamname => 'ASC'}
   
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
