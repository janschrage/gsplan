require 'test_helper'


class DeveloperTest < ActiveSupport::TestCase
fixtures :teamcommitments, :employees  

  def test_empty
    dev = Developer.new()
    assert !dev.valid?
    assert dev.errors.invalid?(:teamcommitment_id)
    assert dev.errors.invalid?(:employee_id)
    assert !dev.save
  end

  def test_create_bogus_commitment
    dev=Developer.new(:teamcommitment_id => 1000, :employee_id => 1)
    assert !dev.valid?
    assert dev.errors.invalid?(:teamcommitment_id)
  end

  def test_create_bogus_ee
    dev=Developer.new(:teamcommitment_id => 2, :employee_id => 1234)
    assert !dev.valid?
    assert dev.errors.invalid?(:employee_id)
  end

  def test_duplicate
    dev=Developer.new(:teamcommitment_id => 2, :employee_id => 2)
    assert !dev.valid?
    assert !dev.save
  end

  def test_create_ok
    dev=Developer.new(:teamcommitment_id => 2, :employee_id => 1)
    assert dev.valid?
    assert dev.save!
  end

end
