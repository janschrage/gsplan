class EmployeesController < ApplicationController
  # GET /employees
  # GET /employees.xml
  layout "employees"
  
  active_scaffold :employee do |config|
    config.label = "Employees"
    config.columns = [:pernr, :name]
    list.sorting = {:name => 'ASC'}
    columns[:pernr].label = "ID"
    columns[:name].label = "Name"
  end

end
