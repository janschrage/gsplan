module TeammembersHelper
  def employee_list
    @employees = Employee.find(:all, :order => "name" )
    return @employees
  end

  def team_list
    @teams = Team.find(:all, :order => "name" )
    return @teams
  end

end
