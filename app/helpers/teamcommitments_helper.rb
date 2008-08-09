module TeamcommitmentsHelper
  def project_list 
    @projects = Project.find(:all, :order => "name" )
    return @projects
  end
  
  def team_list
    @teams = Team.find(:all, :order => "name" )
    return @teams
  end
end
