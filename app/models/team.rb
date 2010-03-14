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
  include Report::Projects

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
    for_date ||= Date.today
    month = get_month_beg_end(for_date)
    begda = month[:first_day]
    endda = month[:last_day]

    commitments = Teamcommitment::find(:all, :conditions => ["team_id = ? and yearmonth >= ? and yearmonth <= ?", self.id, begda, endda])

    return commitments
  end

  def bookings(for_date)
    for_date ||= Date.today
    month = get_month_beg_end(for_date)
    begda = month[:first_day]
    endda = month[:last_day]
    
    last_report_date = Projecttrack::maximum('reportdate', :conditions => ["yearmonth <= ? and yearmonth >= ?",endda, begda])
    
    bookings = Projecttrack.find(:all, :conditions => ["reportdate = ? and team_id = ?",last_report_date,self.id])
    return bookings
  end

  def backlog(for_date)
    # backlog in this definition is open projects without work done
    for_date ||= Date.today 
    month = get_month_beg_end(for_date)
    endda = month[:last_day]
    
    # find all relevant projects
    projects = list_current_projects(endda)
    projects.delete_if { |project|  project.country.team_id != self.id }

    backlog = { :projects   => 0,
                :percentage => 0 
              }
    return backlog if projects.size == 0
    projects.each do |project|
      backlog[:projects] += 1 if project.days_committed(for_date) == 0
    end
    backlog[:percentage] = (100 * backlog[:projects].to_f / projects.size.to_f).round 
    return backlog
  end

  def ad_hoc_work(for_date)
    # ad-hoc work is work done without commitment
    for_date ||= Date.today
    
    # find all commitments and booking for this month, projects only
    committed = commitments(for_date)
    committed.delete_if { |com| com.project.worktype.is_continuous }

    booked = bookings(for_date)
    booked.delete_if { |bk| bk.project.worktype.is_continuous }

    ad_hoc_work = { :tasks      => 0,
                    :percentage => 0,
                  } 
    return ad_hoc_work if booked.size == 0

    booked.each do |bk|
      ad_hoc_work[:tasks] +=1 unless committed.find { |com| com.project_id == bk.project_id }
    end
    ad_hoc_work[:percentage] = (100 * ad_hoc_work[:tasks].to_f / booked.size.to_f).round  
    return ad_hoc_work
  end
end
