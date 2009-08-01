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

class Team < ActiveRecord::Base
  include Report::DateHelpers

  validates_presence_of :name, :description
  validates_uniqueness_of :name
  
  has_many :teammembers
  has_many :employees, :through => :teammembers
  has_many :teamcommitments
  has_many :users
  has_many :countries
#  has_and_belongs_to_many :projects

  DaysPerPerson = 16;

  def capacity(for_date)
    capacity = 0
    teammembers = Teammember::find(:all, :conditions => ["team_id = ? and begda <= ? and endda >= ?", self.id, for_date, for_date])
    teammembers.each { |tm| capacity += DaysPerPerson * (tm.percentage || 100)/100 }
    return capacity
  end

  def usage(for_date)
    monthbegend = get_month_beg_end(for_date)
    month_begin = monthbegend[:first_day]
    month_end = monthbegend[:last_day]

    commitments = Teamcommitment::find(:all, :conditions => ["yearmonth <= ? and yearmonth >= ? and status = ? and team_id = ?",month_end,month_begin,Teamcommitment::StatusAccepted, self.id])
    
    committed = 0
    commitments.each do |commitment|
      committed += commitment.days 
    end
    return committed
  end

  def commitments(for_date)

    for_date=Date.today unless for_date
    month = get_month_beg_end(for_date)
    begda = month[:first_day]
    endda = month[:last_day]

    commitments = Teamcommitment::find(:all, :conditions => ["team_id = ? and yearmonth >= ? and yearmonth <= ?", self.id, begda, endda])

    return commitments
  end
end
