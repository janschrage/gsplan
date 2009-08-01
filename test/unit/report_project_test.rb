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

require 'test_helper'


class ProjectsReportTest < ActiveSupport::TestCase

  include Report::Projects

  def test_current_projects
    # Open projects for this date should be 1,4,8
    prj_list = list_current_projects('2008-08-15'.to_date)
    assert_equal prj_list.size, 3
    assert prj_list.find { |prj| prj.id == 1 }
    assert prj_list.find { |prj| prj.id == 4 }
    assert prj_list.find { |prj| prj.id == 8 }
  end

  def test_parking_lot
    # 1 project in parking lot (nr. 14)
    prj_list = parking_lot
    assert_equal prj_list.size,1
    assert_equal prj_list[0][:project_id], 14
  end

  def test_project_age
    # Open projects for this date should be 1,4,8
    prj_list = project_age_current('2008-08-15'.to_date)
    assert_equal prj_list.size, 3
    assert prj_list.find { |prj| prj[:project_id] == 1 && prj[:wks_since_update] == 2 }  
    assert prj_list.find { |prj| prj[:project_id] == 4 && prj[:wks_since_update] == 0 }  
    assert prj_list.find { |prj| prj[:project_id] == 8 && prj[:wks_since_update] == 4 }  
  end

  def test_project_times
    # projects 1,2,4,8,9
    # 6 days booked on 4 (second of two bookings), rest is 0
    prj_list = project_times('2008-08-01'.to_date, '2008-09-30'.to_date)
    assert_equal 5, prj_list.size
    assert !prj_list[1].nil? 
    assert_equal  0,prj_list[1][:daysbooked]   
    assert !prj_list[2].nil? 
    assert_equal  0,prj_list[2][:daysbooked]   
    assert !prj_list[4].nil? 
    assert_equal  6,prj_list[4][:daysbooked]   
    assert !prj_list[8].nil? 
    assert_equal  0,prj_list[8][:daysbooked]   
    assert !prj_list[9].nil? 
    assert_equal  0,prj_list[9][:daysbooked]   

  end
end
