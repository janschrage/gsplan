class WorktypesController < ApplicationController
  layout "ActScaffold"

   active_scaffold :worktype do |config|
    config.label = "Type of Work"
    config.columns = [:name, :description, :preload]
    list.sorting = {:name => 'ASC'}
    columns[:name].label = "Type of Work"
    columns[:description].label = "Description"
    columns[:preload].label = "Preload?"
    columns[:preload].form_ui = :checkbox
  end
end
