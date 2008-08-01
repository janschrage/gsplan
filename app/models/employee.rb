class Employee < ActiveRecord::Base
  validates_presence_of :pernr, :name
  validates_uniqueness_of :pernr
end
