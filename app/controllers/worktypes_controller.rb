class WorktypesController < ApplicationController
  # GET /worktypes
  # GET /worktypes.xml
   active_scaffold :worktype do |config|
    config.label = "Type of Work"
    config.columns = [:name, :description]
    list.sorting = {:name => 'ASC'}
    columns[:name].label = "Type of Work"
    columns[:description].label = "Description"
  end
end
