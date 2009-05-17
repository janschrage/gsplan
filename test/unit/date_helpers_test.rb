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


class DateHelpersTest < ActiveSupport::TestCase

  include Report::DateHelpers

  def test_month_begend
    mdate = '2009-02-23'.to_date
    result = get_month_beg_end(mdate)   
    assert !result.nil?
    assert_equal result[:first_day], '2009-02-01'.to_date
    assert_equal result[:last_day], '2009-02-28'.to_date

    mdate = '2009-02-01'.to_date
    result = get_month_beg_end(mdate)
    assert !result.nil?
    assert_equal result[:first_day], '2009-02-01'.to_date
    assert_equal result[:last_day], '2009-02-28'.to_date

    mdate = '2009-02-28'.to_date
    result = get_month_beg_end(mdate)
    assert !result.nil?
    assert_equal result[:first_day], '2009-02-01'.to_date
    assert_equal result[:last_day], '2009-02-28'.to_date
  

    mdate = '2008-02-01'.to_date
    result = get_month_beg_end(mdate)
    assert !result.nil?
    assert_equal result[:first_day], '2008-02-01'.to_date
    assert_equal result[:last_day], '2008-02-29'.to_date

  end


end
