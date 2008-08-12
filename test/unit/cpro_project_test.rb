require 'test_helper'

class CproProjectTest < ActiveSupport::TestCase
  fixtures :projects, :cpro_projects

  def test_validation_empty
    cp = CproProject.new()
    assert !cp.valid?
    assert cp.errors.invalid?(:cpro_name)
    assert cp.errors.invalid?(:project_id)
  end

  def test_validation_unique
    cp = CproProject.new( :id => 3, :project_id => 5, :cpro_name => "Identical")
    assert !cp.valid?
    assert cp.errors.invalid?(:cpro_name)
    assert !cp.errors.invalid?(:project_id)
  end
  
  def test_valid
    cp = CproProject.new( :id => 4, :project_id => 5, :cpro_name => "SomethingDifferent")
    assert cp.valid?
  end
end
