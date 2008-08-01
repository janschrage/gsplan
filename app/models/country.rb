class Country < ActiveRecord::Base
    validates_presence_of :isocode, :name
end
