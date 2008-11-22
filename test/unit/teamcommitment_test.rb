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

class TeamcommitmentTest < ActiveSupport::TestCase

  fixtures :projects, :teamcommitments

  def test_validation_empty
    tc = Teamcommitment.new( :id => 3 )
    assert !tc.valid?
    assert tc.errors.invalid?(:team_id)
    assert tc.errors.invalid?(:project_id)
    assert tc.errors.invalid?(:yearmonth)
    assert tc.errors.invalid?(:days)
  end

  def test_validation_invalid_data
    tc = Teamcommitment.new( :id => 4, :team_id => 1, :project_id => 1, :yearmonth => Date::strptime("2010-01-01"), :days => -5 )
    assert !tc.valid?
    assert tc.errors.invalid?(:yearmonth)
    assert tc.errors.invalid?(:days)
  end

  def test_validation_ok
    tc = Teamcommitment.new( :id => 4, :team_id => 1, :project_id => 1, :yearmonth => Date::strptime("2008-09-01"), :days => 5 )
    assert tc.valid?
 end

  def test_unique_commitment
    tc = Teamcommitment.new( :id => 4, :team_id => 1, :project_id => 3, :yearmonth => Date::strptime("2010-10-05"), :days => 15 )
    assert !tc.valid?
    tc2 = Teamcommitment.new( :id => 5, :team_id => 1, :project_id => 3, :yearmonth => Date::strptime("2010-11-05"), :days => 15 )
    assert tc2.valid?
  end

  def test_update
    tc = Teamcommitment.find_by_id(2)
    tc.days = 5
    assert tc.save!
  end
end
