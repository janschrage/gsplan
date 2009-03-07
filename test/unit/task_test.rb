require 'test_helper'


class TaskTest < ActiveSupport::TestCase
fixtures :teamcommitments, :employees  

  def test_empty
    tsk = Task.new()
    assert !tsk.valid?
    assert tsk.errors.invalid?(:teamcommitment_id)
    assert tsk.errors.invalid?(:employee_id)
    assert !tsk.save
  end

  def test_create_bogus_commitment
    tsk=Task.new(:teamcommitment_id => 1000, :employee_id => 1)
    assert !tsk.valid?
    assert tsk.errors.invalid?(:teamcommitment_id)
  end

  def test_create_bogus_ee
    tsk=Task.new(:teamcommitment_id => 2, :employee_id => 1234)
    assert !tsk.valid?
    assert tsk.errors.invalid?(:employee_id)
  end

  def test_duplicate
    tsk=Task.new(:teamcommitment_id => 2, :employee_id => 2)
    assert !tsk.valid?
    assert !tsk.save
  end

  def test_create_ok
    tsk=Task.new(:teamcommitment_id => 2, :employee_id => 1)
    assert tsk.valid?
    assert tsk.save!
  end

end
