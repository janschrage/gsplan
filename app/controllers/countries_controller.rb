class CountriesController < ApplicationController
  # GET /countries
  # GET /countries.xml
  layout "ActScaffold"
  
  active_scaffold :country do |config|
    config.label = "Countries"
    config.columns = [:isocode, :name, :team]
    list.sorting = {:name => 'ASC'}
    columns[:isocode].label = "ISO Code"
    columns[:name].label = "Country"
    columns[:team].label = "Team"
  end
end
