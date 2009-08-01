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
    assert_equal 13,team.usage('2008-08-01'.to_date)
    assert_equal 1,team.usage('2008-10-01'.to_date)     
  end
end
