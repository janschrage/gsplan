class TeamsController < ApplicationController
  # GET /teams
  # GET /teams.xml
  layout "employees"
  
  active_scaffold :team do |config|
    config.label = "Teams"
    config.columns = [:name, :description]
    list.sorting = {:name => 'ASC'}
    columns[:name].label = "Team"
    columns[:description].label = "Description"
  end
end
