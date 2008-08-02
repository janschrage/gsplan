class Employee < ActiveRecord::Base
  has_and_belongs_to_many :teams
  has_many :projects
  
  validates_presence_of :pernr, :name
  validates_uniqueness_of :pernr
end
