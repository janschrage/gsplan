
# GSPlan - Team commitment planning
#
# Copyright (C) 2008 Jan Schrage <jan@jschrage.de>
# 
# This program is free software: you can redistribute it and/or modify it under the terms of the GNU 
# General Public License as published by the Free Software Foundation, either version 3 of the License,
# or (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without
# even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. 
# See the GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License along with this program. 
# If not, see <http://www.gnu.org/licenses/>.

module ProjectsHelper
  
  ProjectStatusImages = [ "/images/icons/stop.png",
                          "/images/icons/run.png",
                          "/images/icons/ok.png",
                          "/images/icons/alert.png",
			  "/images/icons/launch_22x22.png",
			  "/images/icons/agt_announcements.png",
			  "/images/icons/button_cancel.png"]    

  ProjectTrendImages = [ "/images/icons/trend_under.png",
                          "/images/icons/trend_neutral.png",
                          "/images/icons/trend_over.png" ]    

  ProjectDeltaNoDelta = 10 # delta <= 10% is on track

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
      percdelta = ((plan-act) / plan * 100).abs
    else
      percdelta = 0
    end
    
    if percdelta > ProjectDeltaNoDelta
      trend = 0 if act < plan
      trend = 2 if act > plan
    else
      if plan == 0
      	trend = 1 if act <= 0.5 
      	trend = 2 if act >  0.5
      else
        trend = 1
      end
    end
    return ProjectTrendImages[trend]
  end

  def project_quintile(plan, act)
    plan = 0 if plan.nil?
    act = 0 if act.nil?
    # 0 = no work planned, no work done (unfinished business)
    return 0 if plan == 0 and act == 0
    # 6 = no work planned but work done (intransparent)
    return 6 if plan == 0 and act > 0
    # 1..5 0-20%,...,>80% in 20% steps  
    quintile = ((act-plan)/plan*5).abs.ceil.to_i
    return 5 if quintile > 5
    return quintile if quintile <= 5
  end

  def project_type_of(project_id)
    return Project.find_by_id(project_id).worktype.name
  end
end
