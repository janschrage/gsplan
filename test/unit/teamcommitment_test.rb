require 'test_helper'

class TeamcommitmentTest < ActiveSupport::TestCase

  fixtures :projects, :teamcommitments

  def test_validation_empty
    tc = Teamcommitment.new( :id => 3 )
    assert !tc.valid?
    assert tc.errors.invalid?(:team_id)
    assert tc.errors.invalid?(:project_id)
    assert tc.errors.invalid?(:yearmonth)
    assert tc.errors.invalid?(:days)
  end

  def test_validation_invalid_data
    tc = Teamcommitment.new( :id => 3, :team_id => 1, :project_id => 1, :yearmonth => Date::strptime("2010-01-01"), :days => -5 )
    assert !tc.valid?
    assert tc.errors.invalid?(:yearmonth)
    assert tc.errors.invalid?(:days)
  end

  def test_validation_ok
    tc = Teamcommitment.new( :id => 3, :team_id => 1, :project_id => 1, :yearmonth => Date::strptime("2008-09-01"), :days => 5 )
    assert tc.valid?
  end

end
