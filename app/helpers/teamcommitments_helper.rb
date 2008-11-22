module TeamcommitmentsHelper
  
  TeamcommitmentStatusImages = [ "/images/icons/agt_announcements.png",
                                 "/images/icons/ok.png" ]    

  def project_list_current
    # This is for the selection in edit/create. 
    # Pick only projects that are not closed and begin date <= end date of this period, i.e. include overdue
    @projects = Project.find(:all, :conditions => ["status = ? or status = ?", Project::StatusOpen, Project::StatusInProcess], :order => "name" )
    endda = Date::strptime(cookies[:report_date]) || Date.today
    @projects.delete_if { |project|  project.planbeg > endda }
    return @projects
  end
  
  def team_list
    @teams = Team.find(:all, :order => "name" )
    return @teams
  end
  

  def country_by_id(country_id)
    return Country.find_by_id(country_id)
  end

  def teamcommitment_status_image(status)
    return "/images/icons/cache.png" if status.nil?
    return TeamcommitmentStatusImages[status]
  end

end
