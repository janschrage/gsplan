require 'test_helper'

class MyteamControllerTest < ActionController::TestCase

  def test_should_get_index
    get :index, {}, { :user_id => users(:fred).id }
    assert_response :success
  end

  def test_commitments_are_filtered
    get :index, {:report_date => '2008-08-01'}, { :user_id => users(:fred).id }
    tc=assigns(:teamcommitments)
    assert_not_nil tc
    assert_equal 2, tc.size
  end
  
end
