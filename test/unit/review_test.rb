require 'test_helper'

class ReviewTest < ActiveSupport::TestCase

  fixtures :projects, :reviews, :worktypes

  def test_validation_empty
    rev = Review.new( :id => 3 )
    assert !rev.valid?
    assert rev.errors.invalid?(:result)
    assert rev.errors.invalid?(:user_id)
    assert rev.errors.invalid?(:project_id)
    assert rev.errors.invalid?(:notes)
  end

  def test_project_in_process_needs_review_ok
    rev = Review.new( :user_id => 1, :project_id => 1, :notes => "OK", :result => 1 )
    assert rev.valid?
  end

  def test_project_not_in_process
    rev = Review.new( :user_id => 1, :project_id => 2, :notes => "OK", :result => 1 )
    assert !rev.valid?
    assert rev.errors.invalid?(:project_id)

    rev = Review.new( :user_id => 1, :project_id => 3, :notes => "OK", :result => 1 )
    assert !rev.valid?
    assert rev.errors.invalid?(:project_id)

    rev = Review.new( :user_id => 1, :project_id => 4, :notes => "OK", :result => 1 )
    assert !rev.valid?
    assert rev.errors.invalid?(:project_id)

    rev = Review.new( :user_id => 1, :project_id => 5, :notes => "OK", :result => 1 )
    assert !rev.valid?
    assert rev.errors.invalid?(:project_id)

    rev = Review.new( :user_id => 1, :project_id => 6, :notes => "OK", :result => 1 )
    assert !rev.valid?
    assert rev.errors.invalid?(:project_id)

    rev = Review.new( :user_id => 1, :project_id => 7, :notes => "OK", :result => 1 )
    assert !rev.valid?
    assert rev.errors.invalid?(:project_id)
  end

  def test_project_in_process_needs_review_nok
    rev = Review.new( :user_id => 1, :project_id => 8, :notes => "OK", :result => 1 )
    assert !rev.valid?
    assert rev.errors.invalid?(:project_id)
  end

end
