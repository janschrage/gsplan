class Teammember < ActiveRecord::Base
  
  belongs_to :team
  belongs_to :employee
  validates_presence_of :employee_id, :team_id, :begda, :endda
  
 def teamname
    @team = Team.find_by_id(:team_id)
    "#{@team.name}"
  end

  def eename
    @employee = Employee.find_by_id(:employee_id)
    "#{@employee.name}"
  end
end
