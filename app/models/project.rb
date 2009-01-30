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

class Project < ActiveRecord::Base


  StatusOpen = 0
  StatusInProcess = 1
  StatusClosed = 2
  StatusOverdue = 3
  StatusPilot = 4
  StatusProposed = 5
  StatusRejected = 6

  belongs_to :country
  belongs_to :employee
  belongs_to :worktype
  has_many   :teamcommitments
  has_one    :cpro_project
  belongs_to :projectarea
  has_many   :reviews

  validates_presence_of :employee_id, :country_id, :worktype_id, :planbeg, :planend, :name, :planeffort
  validates_uniqueness_of :name
  validate :begda_is_before_endda, :planeffort_is_positive, :reviews_ok_before_pilot_or_close  

  def employeename
    @employee = Employee.find_by_id(employee_id)
    "#{@employee.name}"
  end
  
  def worktypename
    @worktype = Worktype.find_by_id(worktype_id)
    "#{@worktype.name}"
  end

  def countryname
    @country = Country.find_by_id(country_id)
    "#{@country.name}"
  end
  

 protected
  def begda_is_before_endda
    return if planbeg.nil? or planend.nil?
    errors.add(:planend, "End date must not be before begin date.") if planbeg > planend
  end
  
  def planeffort_is_positive
    errors.add(:planeffort, "Planned effort must be >0") if planeffort.nil? || planeffort <= 0
  end

  def reviews_ok_before_pilot_or_close
    return if self.nil?
    return if self.worktype.nil?
    return true unless self.worktype.needs_review
    return true unless self.status == StatusPilot or self.status == StatusClosed

    reviews=Review.find(:all, :conditions => ["project_id = ?", self.id])
    
    rSpec   = false
    rDesign = false
    rCode   = false

    if reviews.nil?
      errors.add(:status, "All reviews missing. Cannot pilot or close project.")
      return false
    end

    reviews.each do |review|
      rSpec   = true if (review.rtype == Review::ReviewSpec   and (review.result == Review::ResultOK or review.result == Review::ResultOKwithComments))
      rDesign = true if (review.rtype == Review::ReviewDesign and (review.result == Review::ResultOK or review.result == Review::ResultOKwithComments))
      rCode   = true if (review.rtype == Review::ReviewCode   and (review.result == Review::ResultOK or review.result == Review::ResultOKwithComments))
    end

    errors.add(:status, "Spec review is missing or failed. Cannot pilot or close project.") unless rSpec
    errors.add(:status, "Design review is missing or failed. Cannot pilot or close project.") unless rDesign
    errors.add(:status, "Code review is missing or failed. Cannot pilot or close project.") unless rCode  
  end

end
