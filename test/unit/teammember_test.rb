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

class TeammemberTest < ActiveSupport::TestCase
  fixtures :teams, :employees
  
  def test_validation_empty
    tm = Teammember.new()
    assert !tm.valid?
    assert tm.errors.invalid?(:team_id)
    assert tm.errors.invalid?(:employee_id)
    assert tm.errors.invalid?(:begda)
    assert tm.errors.invalid?(:endda)
    assert tm.errors.invalid?(:percentage)
  end

  def test_validation_percentage
    # > 100
    tm = Teammember.new( :id =>3, :team_id => 1, :employee_id => 1, :begda => Date::strptime("2008-08-01"), :endda => Date::strptime("2010-12-31"), :percentage => 120)
    assert !tm.valid?
    assert !tm.errors.invalid?(:team_id)
    assert !tm.errors.invalid?(:employee_id)
    assert !tm.errors.invalid?(:begda)
    assert !tm.errors.invalid?(:endda)
    assert tm.errors.invalid?(:percentage)
    # < 0
    tm2 = Teammember.new( :id =>3, :team_id => 1, :employee_id => 1, :begda => Date::strptime("2008-08-01"), :endda => Date::strptime("2010-12-31"), :percentage => -1)
    assert !tm2.valid?
    assert !tm2.errors.invalid?(:team_id)
    assert !tm2.errors.invalid?(:employee_id)
    assert !tm2.errors.invalid?(:begda)
    assert !tm2.errors.invalid?(:endda)
    assert tm2.errors.invalid?(:percentage)
    # string
    tm3 = Teammember.new( :id =>4, :team_id => 1, :employee_id => 1, :begda => Date::strptime("2008-08-01"), :endda => Date::strptime("2010-12-31"), :percentage => "xxx")
    assert !tm3.valid?
    assert !tm3.errors.invalid?(:team_id)
    assert !tm3.errors.invalid?(:employee_id)
    assert !tm3.errors.invalid?(:begda)
    assert !tm3.errors.invalid?(:endda)
    assert tm3.errors.invalid?(:percentage)
  end  
  
end
