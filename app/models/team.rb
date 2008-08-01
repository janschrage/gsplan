class Team < ActiveRecord::Base
  validates_presence_of :name, :description
  validates_uniqueness_of :name
  
  has_many :teammembers
end
