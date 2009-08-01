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


class WorktypeReportTest < ActiveSupport::TestCase

  include Report::Worktype

  def test_worktype_tracking
    wt_track = worktype_tracking('2008-08-01'.to_date, '2008-09-30'.to_date)
    assert_equal 3,wt_track.size
    assert wt_track.find { |wt| wt[:team_id] == 1 && wt[:worktype_id] == 1 && wt[:daysbooked] == 7 }  
    assert wt_track.find { |wt| wt[:team_id] == 1 && wt[:worktype_id] == 1 && wt[:daysbooked] == 6 }  
    assert wt_track.find { |wt| wt[:team_id] == 2 && wt[:worktype_id] == 1 && wt[:daysbooked] == 8 }  
  end

  def test_worktype_cumul
    wt_track = worktype_cumul('2008-08-01'.to_date, '2008-09-30'.to_date)
    assert_equal 2,wt_track.size
    assert wt_track.find { |wt| wt[:team_id] == 1 && wt[:worktype_id] == 1 && wt[:daysbooked] == 13 }  
    assert wt_track.find { |wt| wt[:team_id] == 2 && wt[:worktype_id] == 1 && wt[:daysbooked] == 8 }  
  end

  def test_worktype_dist
    # only worktype 1 filled, with 14 days
    wt_track = calculate_worktype_distribution('2008-09-01'.to_date)
    assert_equal 1,wt_track.size
    assert_equal 14,wt_track[1][:daysbooked]
  end

end
