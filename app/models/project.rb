class Project < ActiveRecord::Base

  StatusType = Struct.new(:id,:name)

  StatusOpen = 0
  StatusInProgress = 1
  StatusClosed = 2
  StatusOverdue = 3
  
  belongs_to :country
  belongs_to :employee
  belongs_to :worktype
  has_many   :teamcommitments
  has_one    :cpro_project
  
  validates_presence_of :employee_id, :country_id, :worktype_id, :planbeg, :planend, :name, :planeffort
  validates_uniqueness_of :name
  validate :begda_is_before_endda, :planeffort_is_positive
  
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
  
  def project_status_text(status)
    if status == nil
      statustext = "not set"
    else
      statustext = project_status_list[status][1]
    end
    return statustext             
  end
  
  def project_status_list
    @statuslist = []
    @statuslist << StatusType.new("0","open")
    @statuslist << StatusType.new("1", "in progress")
    @statuslist << StatusType.new("2", "closed")
    @statuslist << StatusType.new("3", "overdue")
    return @statuslist
  end
  
 protected
  def begda_is_before_endda
    return if planbeg.nil? or planend.nil?
    errors.add(:planend, "End date must not be before begin date.") if planbeg > planend
  end
  
  def planeffort_is_positive
    errors.add(:planeffort, "Planned effort must be >0") if planeffort.nil? || planeffort <= 0
  end
end
