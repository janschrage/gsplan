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

class UserTest < ActiveSupport::TestCase
  # Create user and set password
  def test_create_user
    freddie = User.new
    assert !freddie.nil?

    freddie.name = 'freddie'
    # No save with blank passwords
    freddie.password=''
    assert !freddie.save

    # Should save with password
    freddie.password='testmequick'
    assert_equal freddie.password, 'testmequick'
    assert freddie.save
  end

  def test_authenticate_user
    # Exists
    fred = User.authenticate('fred','testme')
    assert !fred.nil?
    assert_equal fred.name, 'fred'

    # Wrong password
    fred2 = User.authenticate('fred','wrong')
    assert fred2.nil?

    # Capitalization
    fred3 = User.authenticate('Fred','testme')
    assert fred3.nil?

    # Does not exist
    barney = User.authenticate('barney','testme')
    assert barney.nil?
  end

  def test_destroy_last_user
    test = User.find_by_name('test')
    test.destroy
    fred = User.find_by_name('fred')
    assert_raise(RuntimeError, "Can't delete last user") { fred.destroy }
  end
end
