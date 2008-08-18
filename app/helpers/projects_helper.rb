module ProjectsHelper
  
  ProjectStatusImages = [ "/images/icons/stop.png",
                          "/images/icons/run.png",
                          "/images/icons/ok.png",
                          "/images/icons/alert.png" ]    

  ProjectTrendImages = [ "/images/icons/trend_under.png",
                          "/images/icons/trend_neutral.png",
                          "/images/icons/trend_over.png" ]    

  ProjectDeltaNoDelta = 5 # delta <= 5% is on track

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

  def project_trend_image(plan,act)
    plan = 0 if plan.nil?
    act = 0 if act.nil?
    
    if plan != 0
      percdelta = (plan-act).abs / plan * 100
    else
      percdelta = 0
    end
    
    if percdelta > ProjectDeltaNoDelta 
      trend = 0 if act < plan
      trend = 2 if act > plan
    else
      trend = 1
    end
    return ProjectTrendImages[trend]
  end

end
