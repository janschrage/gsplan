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

class CountryTest < ActiveSupport::TestCase
  def test_validation_empty
    ct = Country.new( :id => 3 )
    assert !ct.valid?
    assert ct.errors.invalid?(:name)
    assert ct.errors.invalid?(:isocode)
  end

  def test_validation_ok
    ct = Country.new( :id => 4, :name => 'test456', :isocode => 'TX' )
    assert ct.valid?    
  end
end
