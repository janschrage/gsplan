class CountriesController < ApplicationController
  # GET /countries
  # GET /countries.xml
  active_scaffold :country do |config|
    config.label = "Countries"
    config.columns = [:isocode, :name]
    list.sorting = {:name => 'ASC'}
    columns[:isocode].label = "ISO Code"
    columns[:name].label = "Country"
  end
end
