class ProjectsController < ApplicationController
  layout "projects"
  
  active_scaffold :project do |config|
    config.label = "Projects"
    config.list.columns = [:name, :planbeg, :planend, :planeffort, :countryname, :worktypename, :employeename]
    config.columns = [:name, :planbeg, :planend, :planeffort, :countryname, :worktypename, :employeename]
    list.sorting = {:planbeg => 'ASC'}
    columns[:name].label = "Project"  
    columns[:employeename].label = 'Responsible'
    columns[:worktypename].label = 'Type'
    columns[:countryname].label = 'Country'
    columns[:planbeg].label = 'Begin (plan)'
    columns[:planend].label = 'End (plan)'
    columns[:planbeg].label = 'Begin (plan)'
  end

end
