require 'test_helper'

class ReviewersTest < ActiveSupport::TestCase
  fixtures :projects, :employees

  def test_empty
    rev = Reviewers.new()
    assert !rev.valid?
    assert rev.errors.invalid?(:project_id)
    assert rev.errors.invalid?(:employee_id)
    assert !rev.save
  end

  def test_create_bogus_project
    rev=Reviewers.new(:project_id => 1000, :employee_id => 1)
    assert !rev.valid?
    assert rev.errors.invalid?(:project_id)
  end

  def test_create_bogus_ee
    rev=Reviewers.new(:project_id => 1, :employee_id => 1234)
    assert !rev.valid?
    assert rev.errors.invalid?(:employee_id)
  end

  def test_duplicate
    rev=Reviewers.new(:project_id => 2, :employee_id => 2)
    assert !rev.valid?
    assert !rev.save
  end

  def test_create_ok
    rev=Reviewers.new(:project_id => 1, :employee_id => 2)
    assert rev.valid?
    assert rev.save!
  end
end
