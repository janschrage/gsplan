class Projectarea < ActiveRecord::Base

  validates_presence_of :area
  validates_uniqueness_of :area

end
