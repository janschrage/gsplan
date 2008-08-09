require 'test_helper'

class EmployeeTest < ActiveSupport::TestCase
  
  fixtures :employees
  
  def test_empty_ee
    ee=Employee.new
    assert !ee.valid?
    assert ee.errors.invalid?(:pernr)
    assert ee.errors.invalid?(:name)
  end
  
  def test_new_ee_existing_pernr
    ee=Employee.new(:id => 3, :pernr => 'I123456', :name => 'George Fawn' )
    assert !ee.valid?
    assert ee.errors.invalid?(:pernr)
    assert !ee.errors.invalid?(:name)    
  end
    
  def test_new_ee_valid
    ee=Employee.new(:id => 3, :pernr => 'I123458', :name => 'George Fawn' )
    assert ee.valid?
  end
end
