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

class TeamTest < ActiveSupport::TestCase
  def test_validation_empty
    team = Team.new( :id => 3 )
    assert !team.valid?
    assert team.errors.invalid?(:name)
    assert team.errors.invalid?(:description)
  end

  def test_validation_ok
    team = Team.new( :id => 4, :name => 'test456', :description => 'test team' )
    assert team.valid?    
  end

  def test_capacity
    team = Team.find_by_id(1)
    assert_equal 28,team.capacity('2008-08-01'.to_date)
    assert_equal 16,team.capacity('2008-10-01'.to_date)     
  end

  def test_usage
    team = Team.find_by_id(1)
    assert_equal 12,team.usage('2008-08-01'.to_date)
    assert_equal 1,team.usage('2008-10-01'.to_date)     
  end

  def test_bookings
    team1 = Team.find_by_id(1)
    bookings = team1.bookings('2008-08-01'.to_date)
    assert_equal 1,bookings.size
    assert_equal 7,bookings[0].daysbooked
    assert_equal 4,bookings[0].project_id

    team2 = Team.find_by_id(2)
    bookings2 = team2.bookings('2008-09-01'.to_date)
    assert_equal 2,bookings2.size
    assert bookings2.find { |bk| bk.project_id == 4 && bk.daysbooked == 3 }
    assert bookings2.find { |bk| bk.project_id == 2 && bk.daysbooked == 5 }
  end

  def test_backlog
    team = Team.find_by_id(1)
    backlog = team.backlog('2008-08-01'.to_date)
    assert_equal 2,backlog[:projects]
    assert_equal 67,backlog[:percentage]
  end

  def test_ad_hoc
    team2 = Team.find_by_id(2)
    ad_hoc = team2.ad_hoc_work('2008-09-01'.to_date)
    assert_equal 2,ad_hoc[:tasks]
    assert_equal 100,ad_hoc[:percentage]

    team1 = Team.find_by_id(1)
    ad_hoc = team1.ad_hoc_work('2008-08-01'.to_date)
    assert_equal 0,ad_hoc[:tasks]
    assert_equal 0,ad_hoc[:percentage]

    ad_hoc = team1.ad_hoc_work('2008-11-01'.to_date)
    assert_equal 1,ad_hoc[:tasks]
    assert_equal 50,ad_hoc[:percentage]
  end
end
