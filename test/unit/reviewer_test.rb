require 'test_helper'

class ReviewerTest < ActiveSupport::TestCase
  fixtures :projects, :employees

  def test_empty
    rev = Reviewer.new()
    assert !rev.valid?
    assert rev.errors.invalid?(:project_id)
    assert rev.errors.invalid?(:employee_id)
    assert !rev.save
  end

  def test_create_bogus_project
    rev=Reviewer.new(:project_id => 1000, :employee_id => 1)
    assert !rev.valid?
    assert rev.errors.invalid?(:project_id)
  end

  def test_create_bogus_ee
    rev=Reviewer.new(:project_id => 1, :employee_id => 1234)
    assert !rev.valid?
    assert rev.errors.invalid?(:employee_id)
  end

  def test_duplicate
    rev=Reviewer.new(:project_id => 2, :employee_id => 2)
    assert !rev.valid?
    assert !rev.save
  end

  def test_create_ok
    rev=Reviewer.new(:project_id => 1, :employee_id => 2)
    assert rev.valid?
    assert rev.save!
  end

  def test_ee_is_not_reviewer
    rev=Reviewer.new(:project_id => 1, :employee_id => 3)
    assert !rev.valid?
    assert rev.errors.invalid?(:employee_id)
  end
end
