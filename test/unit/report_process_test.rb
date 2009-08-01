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


class ProcessReportTest < ActiveSupport::TestCase

  include Report::Process

  def test_wip
  # Work in progress: test fixtures have 8 projects that are open, in process or testing   
    assert_equal wip(), 8
  end

  def test_pct
    assert_equal pct('2008-08-01'.to_date, '2008-08-31'.to_date), 31
    assert_equal pct('2008-08-20'.to_date, '2008-08-31'.to_date), 12
    assert_equal pct('2008-08-20'.to_date, '2008-09-09'.to_date), 21
    assert_equal pct('2008-08-20'.to_date, '2008-09-10'.to_date), 11
  end

  def test_plt
    prj_list = project_plt('2008-08-01'.to_date, '2008-08-31'.to_date)
    assert_equal prj_list[0][:plt], 21
    assert_equal prj_list[0][:plt_as_perc], 2100.0
  end

end
