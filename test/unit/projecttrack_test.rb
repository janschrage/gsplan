require 'test_helper'

class ProjecttrackTest < ActiveSupport::TestCase
   fixtures :projects, :teams
   
  def test_validation_empty
    pt = Projecttrack.new( :id => 3 )
    assert !pt.valid?
    assert pt.errors.invalid?(:team_id)
    assert pt.errors.invalid?(:project_id)
    assert pt.errors.invalid?(:yearmonth)
    assert pt.errors.invalid?(:daysbooked)
    assert pt.errors.invalid?(:reportdate)
  end

  def test_validation_ok
    pt = Projecttrack.new( :id => 4, :team_id => 1, :project_id => 4, :yearmonth => Date::strptime("2008-09-01"), :reportdate => Date::strptime("2008-09-01"), :daysbooked => 5 )
    assert pt.valid?
  end

  def test_validation_numericality
    pt = Projecttrack.new( :id => 4, :team_id => 1, :project_id => 4, :yearmonth => Date::strptime("2008-09-01"), :reportdate => Date::strptime("2008-09-01"), :daysbooked => "xxx" )
    assert !pt.valid?
    assert !pt.errors.invalid?(:reportdate)
    assert !pt.errors.invalid?(:team_id)
    assert !pt.errors.invalid?(:project_id)
    assert !pt.errors.invalid?(:yearmonth)
    assert pt.errors.invalid?(:daysbooked)
  end
  
  def test_validation_not_zero
    pt = Projecttrack.new( :id => 4, :team_id => 1, :project_id => 4, :yearmonth => Date::strptime("2008-09-01"), :reportdate => Date::strptime("2008-09-01"), :daysbooked => 0 )
    assert !pt.valid?
    assert !pt.errors.invalid?(:reportdate)
    assert !pt.errors.invalid?(:team_id)
    assert !pt.errors.invalid?(:project_id)
    assert !pt.errors.invalid?(:yearmonth)
    assert pt.errors.invalid?(:daysbooked)
  end

  def test_validation_not_negative
    pt = Projecttrack.new( :id => 4, :team_id => 1, :project_id => 4, :yearmonth => Date::strptime("2008-09-01"), :reportdate => Date::strptime("2008-09-01"), :daysbooked => -2 )
    assert !pt.valid?
    assert !pt.errors.invalid?(:reportdate)
    assert !pt.errors.invalid?(:team_id)
    assert !pt.errors.invalid?(:project_id)
    assert !pt.errors.invalid?(:yearmonth)
    assert pt.errors.invalid?(:daysbooked)
  end
  
  def test_validation_outoftimeframe
    pt = Projecttrack.new( :id => 5, :team_id => 1, :project_id => 4, :yearmonth => Date::strptime("2008-11-01"), :reportdate => Date::strptime("2008-09-01"), :daysbooked => 5 )
    assert !pt.valid?
    assert !pt.errors.invalid?(:reportdate)
    assert !pt.errors.invalid?(:team_id)
    assert !pt.errors.invalid?(:project_id)
    assert pt.errors.invalid?(:yearmonth)
    assert !pt.errors.invalid?(:daysbooked)
  end

  def test_validation_crystal_ball
    pt = Projecttrack.new( :id => 6, :team_id => 1, :project_id => 4, :yearmonth => Date::strptime("2008-09-01"), :reportdate => Date::strptime("2008-08-15"), :daysbooked => 5 )
    assert !pt.valid?
    assert !pt.errors.invalid?(:reportdate)
    assert !pt.errors.invalid?(:team_id)
    assert !pt.errors.invalid?(:project_id)
    assert pt.errors.invalid?(:yearmonth)
    assert !pt.errors.invalid?(:daysbooked)
  end

  def test_validation_unique
    pt = Projecttrack.new( :id => 8, :team_id => 1, :project_id => 4, :yearmonth => Date::strptime("2008-09-01"), :reportdate => Date::strptime("2008-09-15"), :daysbooked => 20 )
    assert !pt.valid?
    assert pt.errors.invalid?(:reportdate)
    assert !pt.errors.invalid?(:team_id)
    assert !pt.errors.invalid?(:project_id)
    assert !pt.errors.invalid?(:yearmonth)
    assert !pt.errors.invalid?(:daysbooked)
  end
end
