class ProjectsController < ApplicationController
  layout "projects"
  
  active_scaffold :project do |config|
    config.label = "Projects"
    config.list.columns.exclude :employee_id, :worktype_id, :country_id
 #   config.list.columns = [:name, :planbeg, :planend, :planeffort, :country_id, :worktype_id, :employee_id]
   config.columns = [:name, :planbeg, :planend, :planeffort, :employee_id, :worktype_id, :country_id]
    list.sorting = {:planbeg => 'ASC'}
    columns[:name].label = "Project"  
    columns[:employee_id].label = 'Responsible'
    columns[:worktype_id].label = 'Type'
    columns[:country_id].label = 'Country'
    columns[:planbeg].label = 'Begin (plan)'
    columns[:planend].label = 'End (plan)'
    columns[:planbeg].label = 'Begin (plan)'
  end

end
