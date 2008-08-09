module TeamcommitmentsHelper
 
  ProjectStatusImages = [ "images/icons/clock_stop.png",
                          "images/icons/clock_go.png",
                          "images/icons/tick.png" ]    
 
  def project_list 
    @projects = Project.find(:all, :order => "name" )
    return @projects
  end
  
  def team_list
    @teams = Team.find(:all, :order => "name" )
    return @teams
  end
  
  def project_status_image(status)
    return ProjectStatusImages[status]
  end
end
