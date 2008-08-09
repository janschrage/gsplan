class CproProject < ActiveRecord::Base
  belongs_to :project
  
  validates_presence_of :project_id, :cpro_name
  validates_uniqueness_of :cpro_name
  validates_numericality_of :project_id
end
