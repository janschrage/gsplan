require 'test_helper'


class ProjectTest < ActiveSupport::TestCase

  fixtures :projects

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
end
