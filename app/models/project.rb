class Project < ActiveRecord::Base

  StatusType = Struct.new(:id,:name)
  
  belongs_to :country
  belongs_to :employee
  belongs_to :worktype

  has_many :teamcommitments
  
  validates_presence_of :employee_id, :country_id, :worktype_id, :planbeg, :planend, :name, :planeffort
  validates_uniqueness_of :name
  validate :begda_is_before_endda
  
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
    return @statuslist
  end
  
 protected
  def begda_is_before_endda
    errors.add(:planend, "End date must not be before begin date.") if planbeg > planend
  end
end
