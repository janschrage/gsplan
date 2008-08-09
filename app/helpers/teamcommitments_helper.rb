module TeamcommitmentsHelper
 
  ProjectStatusImages = [ "images/icons/stop.png",
                          "images/icons/run.png",
                          "images/icons/ok.png" ]    
 
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
