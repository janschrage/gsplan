module CproProjectsHelper

  def project_list 
    @projects = Project.find(:all, :order => "name" )
    return @projects
  end
  
  def project_from_id(project_id)
    @project = Project.find_by_id(project_id)
    return @project.name unless @project == nil
  end
end
