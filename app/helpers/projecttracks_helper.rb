module ProjecttracksHelper
  TrackStatusImages = [ "/images/icons/ok.png",
                        "/images/icons/error.png"]

  def track_status_image(status)
    return TrackStatusImages[0] if status 
    return TrackStatusImages[1]
  end
  
  def project_by_id(project_id)
    return Project.find_by_id(project_id).name
  end
  
  def team_by_id(team_id)
    return Team.find_by_id(team_id).name
  end  
end
