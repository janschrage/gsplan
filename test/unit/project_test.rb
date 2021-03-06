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


class ProjectTest < ActiveSupport::TestCase

  fixtures :projects, :reviews, :projecttracks

  def test_validation_empty
    prj = Project.new( :id => 3 )
    assert !prj.valid?
    assert prj.errors.invalid?(:name)
    assert prj.errors.invalid?(:planbeg)
    assert prj.errors.invalid?(:planend)
    assert prj.errors.invalid?(:planeffort)
    assert prj.errors.invalid?(:worktype_id)
    assert prj.errors.invalid?(:country_id)
    assert prj.errors.invalid?(:employee_id)
  end

  def test_validation_name_plan
    prj = Project.new( :id => 3, :name => "TestProject-1", :planbeg => Date::strptime("2008-08-31"), :planend => Date::strptime("2008-08-01"), :planeffort => "-5", :worktype_id => "1", :country_id => "1", :employee_id => "1")
    assert !prj.valid?
    assert prj.errors.invalid?(:name)
    assert prj.errors.invalid?(:planend)
    assert prj.errors.invalid?(:planeffort)
  end

  def test_valid_project
    prj = Project.new( :id => 3, :name => "TestProject-3", :planbeg => Date::strptime("2008-08-31"), :planend => Date::strptime("2008-09-30"), :planeffort => "5", :worktype_id => "1", :country_id => "1", :employee_id => "1")
    assert prj.valid?
  end

  def test_update
    prj = Project.find_by_id(1)
    prj.planend = Date::strptime("2008-09-30");
    assert prj.save!
  end

  def test_update_no_reviews_nok
    prj = Project.find_by_id(2)
    prj.planend = Date::strptime("2008-09-30");
    assert !prj.save
  end

  def test_days_committed
    prj4 = Project.find_by_id(4)
    assert_equal 12,prj4.days_committed('2008-08-10'.to_date)
    assert_equal 12,prj4.days_committed
    prj1 = Project.find_by_id(1)
    assert_equal 1,prj1.days_committed('2008-08-10'.to_date)
    assert_equal 1,prj1.days_committed('2008-10-10'.to_date)
    assert_equal 2,prj1.days_committed
  end

  def test_days_booked
    prj4 = Project.find_by_id(4)
    assert_equal 9,prj4.days_booked('2008-09-10'.to_date)
    prj2 = Project.find_by_id(2)
    assert_equal 5,prj2.days_booked('2008-09-10'.to_date)
  end
end
