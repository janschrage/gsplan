class Employee < ActiveRecord::Base
  validates_presence_of :pernr, :name
end
