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
  
  def countMembers(team_id,report_date)
    members = []
    members=@self.find_by_team_id(team_id)
    members.each do |member| 
      if member.endda >= report_date then
         count=count+1 
      end
    end
    return count
  end
 
end
