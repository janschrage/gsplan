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
    tc = Teamcommitment.new( :id => 4, :team_id => 1, :project_id => 1, :yearmonth => Date::strptime("2010-01-01"), :days => -5 )
    assert !tc.valid?
    assert tc.errors.invalid?(:yearmonth)
    assert tc.errors.invalid?(:days)
  end

  def test_validation_ok
    tc = Teamcommitment.new( :id => 4, :team_id => 1, :project_id => 1, :yearmonth => Date::strptime("2008-09-01"), :days => 5 )
    assert tc.valid?
 end

  def test_unique_commitment
    tc = Teamcommitment.new( :id => 4, :team_id => 1, :project_id => 3, :yearmonth => Date::strptime("2010-10-05"), :days => 15 )
    assert !tc.valid?
    tc2 = Teamcommitment.new( :id => 5, :team_id => 1, :project_id => 3, :yearmonth => Date::strptime("2010-11-05"), :days => 15 )
    assert tc2.valid?
  end
end
