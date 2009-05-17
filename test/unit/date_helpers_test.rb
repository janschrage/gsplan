require 'test_helper'


class DateHelpersTest < ActiveSupport::TestCase

  include Report::DateHelpers

  def test_month_begend
    mdate = '2009-02-23'.to_date
    result = get_month_beg_end(mdate)   
    assert !result.nil?
    assert_equal result[:first_day], '2009-02-01'.to_date
    assert_equal result[:last_day], '2009-02-28'.to_date

    mdate = '2009-02-01'.to_date
    result = get_month_beg_end(mdate)
    assert !result.nil?
    assert_equal result[:first_day], '2009-02-01'.to_date
    assert_equal result[:last_day], '2009-02-28'.to_date

    mdate = '2009-02-28'.to_date
    result = get_month_beg_end(mdate)
    assert !result.nil?
    assert_equal result[:first_day], '2009-02-01'.to_date
    assert_equal result[:last_day], '2009-02-28'.to_date
  

    mdate = '2008-02-01'.to_date
    result = get_month_beg_end(mdate)
    assert !result.nil?
    assert_equal result[:first_day], '2008-02-01'.to_date
    assert_equal result[:last_day], '2008-02-29'.to_date

  end


end
