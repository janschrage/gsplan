class Teamcommitment < ActiveRecord::Base
  belongs_to :team
  belongs_to :project
  
  validates_presence_of :team_id, :project_id, :yearmonth, :days
  validates_numericality_of :days
  
end
