class Country < ActiveRecord::Base
    validates_presence_of :isocode, :name
    validates_uniqueness_of :isocode, :name
    has_many :projects
    
end
