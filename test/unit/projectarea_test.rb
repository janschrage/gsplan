require 'test_helper'

class ProjectareaTest < ActiveSupport::TestCase
 
  def test_validation_empty
    prjarea = Projectarea.new( :id => 3 )
    assert !prjarea.valid?
    assert prjarea.errors.invalid?(:area)
  end

  def test_area_is_unique
    area1 = Projectarea.new( :area => "notunique" )
    assert !area1.valid?
    assert area1.errors.invalid?(:area)
  end

  def test_valid_area
    area = Projectarea.new( :area => "valid" )
    assert area.valid?
  end

  def test_2_valid_areas
    area1 = Projectarea.new( :area => "valid2" )
    assert area1.valid?
    area2 = Projectarea.new( :area => "valid3" )
    assert area2.valid?
  end
end
