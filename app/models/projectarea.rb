class Projectarea < ActiveRecord::Base

  has_many :projects

  validates_presence_of :area
  validates_uniqueness_of :area

end
