class Teammember < ActiveRecord::Base
  
  belongs_to :team
  belongs_to :employee
  validates_presence_of :employee_id, :team_id, :begda, :endda, :percentage 
  validates_numericality_of :percentage
  validate :begda_is_before_endda, :percentage_is_valid
  
 def teamname
    @team = Team.find_by_id(team_id)
    "#{@team.name}"
  end

  def eename
    @employee = Employee.find_by_id(employee_id)
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
  
protected
  def begda_is_before_endda
    return if begda.nil? or endda.nil?
    errors.add(:endda, "End date must not be before begin date.") if begda > endda
  end
  
  def percentage_is_valid
    return if percentage.nil?
    errors.add(:percentage, "Percentage must be between 0 and 100.") if percentage < 0 or percentage > 100
  end
end
