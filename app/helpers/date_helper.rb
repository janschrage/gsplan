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


# Implements helpers for date calculations in reporting.
module DateHelper

  # Calculates begin and end date of the month in which curdate lies.
  def get_month_beg_end(curdate)
    month_begin = Date::strptime(curdate.year().to_s+'-'+curdate.month().to_s+'-01')
    month_end = (month_begin>>(1)) - 1
    month = { :first_day => month_begin,
              :last_day  => month_end }
    return month
  end
end