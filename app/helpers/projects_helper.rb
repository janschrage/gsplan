module ProjectsHelper
  
  ProjectStatusImages = [ "/images/icons/stop.png",
                          "/images/icons/run.png",
                          "/images/icons/ok.png",
                          "/images/icons/alert.png" ]    

  def country_list
    @countries = Country.find(:all, :order => "name" )
    return @countries
  end
  
  def worktype_list
    @worktypes = Worktype.find(:all, :order => "name" )  
    return @worktypes
  end
  
  def employee_list
    @employees = Employee.find(:all, :order => "name" )
    return @employees
  end

  def project_status_image(status)
    return "/images/icons/cache.png" if status.nil?
    return ProjectStatusImages[status]
  end
   
end
