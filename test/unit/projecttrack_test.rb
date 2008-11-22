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

class ProjecttrackTest < ActiveSupport::TestCase
   fixtures :projects, :teams
   
  def test_validation_empty
    pt = Projecttrack.new( :id => 3 )
    assert !pt.valid?
    assert pt.errors.invalid?(:team_id)
    assert pt.errors.invalid?(:project_id)
    assert pt.errors.invalid?(:yearmonth)
    assert pt.errors.invalid?(:daysbooked)
    assert pt.errors.invalid?(:reportdate)
  end

  def test_validation_ok
    pt = Projecttrack.new( :id => 4, :team_id => 1, :project_id => 4, :yearmonth => Date::strptime("2008-09-01"), :reportdate => Date::strptime("2008-09-01"), :daysbooked => 5 )
    assert pt.valid?
  end

  def test_validation_numericality
    pt = Projecttrack.new( :id => 4, :team_id => 1, :project_id => 4, :yearmonth => Date::strptime("2008-09-01"), :reportdate => Date::strptime("2008-09-01"), :daysbooked => "xxx" )
    assert !pt.valid?
    assert !pt.errors.invalid?(:reportdate)
    assert !pt.errors.invalid?(:team_id)
    assert !pt.errors.invalid?(:project_id)
    assert !pt.errors.invalid?(:yearmonth)
    assert pt.errors.invalid?(:daysbooked)
  end
  
  def test_validation_not_zero
    pt = Projecttrack.new( :id => 4, :team_id => 1, :project_id => 4, :yearmonth => Date::strptime("2008-09-01"), :reportdate => Date::strptime("2008-09-01"), :daysbooked => 0 )
    assert !pt.valid?
    assert !pt.errors.invalid?(:reportdate)
    assert !pt.errors.invalid?(:team_id)
    assert !pt.errors.invalid?(:project_id)
    assert !pt.errors.invalid?(:yearmonth)
    assert pt.errors.invalid?(:daysbooked)
  end

  def test_validation_not_negative
    pt = Projecttrack.new( :id => 4, :team_id => 1, :project_id => 4, :yearmonth => Date::strptime("2008-09-01"), :reportdate => Date::strptime("2008-09-01"), :daysbooked => -2 )
    assert !pt.valid?
    assert !pt.errors.invalid?(:reportdate)
    assert !pt.errors.invalid?(:team_id)
    assert !pt.errors.invalid?(:project_id)
    assert !pt.errors.invalid?(:yearmonth)
    assert pt.errors.invalid?(:daysbooked)
  end
  
  def test_validation_outoftimeframe
    pt = Projecttrack.new( :id => 5, :team_id => 1, :project_id => 4, :yearmonth => Date::strptime("2008-11-01"), :reportdate => Date::strptime("2008-09-01"), :daysbooked => 5 )
    assert !pt.valid?
    assert !pt.errors.invalid?(:reportdate)
    assert !pt.errors.invalid?(:team_id)
    assert !pt.errors.invalid?(:project_id)
    assert pt.errors.invalid?(:yearmonth)
    assert !pt.errors.invalid?(:daysbooked)
  end

  def test_validation_crystal_ball
    pt = Projecttrack.new( :id => 6, :team_id => 1, :project_id => 4, :yearmonth => Date::strptime("2008-09-01"), :reportdate => Date::strptime("2008-08-15"), :daysbooked => 5 )
    assert !pt.valid?
    assert !pt.errors.invalid?(:reportdate)
    assert !pt.errors.invalid?(:team_id)
    assert !pt.errors.invalid?(:project_id)
    assert pt.errors.invalid?(:yearmonth)
    assert !pt.errors.invalid?(:daysbooked)
  end

  def test_validation_unique
    pt = Projecttrack.new( :id => 8, :team_id => 1, :project_id => 4, :yearmonth => Date::strptime("2008-09-01"), :reportdate => Date::strptime("2008-09-15"), :daysbooked => 20 )
    assert !pt.valid?
    assert pt.errors.invalid?(:reportdate)
    assert !pt.errors.invalid?(:team_id)
    assert !pt.errors.invalid?(:project_id)
    assert !pt.errors.invalid?(:yearmonth)
    assert !pt.errors.invalid?(:daysbooked)
  end

  def test_update
    pt = Projecttrack.find(1)
    pt.daysbooked = 7
    assert pt.save!
  end
end
