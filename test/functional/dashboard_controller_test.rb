require 'test_helper'

class DashboardControllerTest < ActionController::TestCase

  def test_should_get_index
    get :index, {}, { :user_id => users(:fred).id }
    assert_response :success
  end

  def test_report_callback
    #Note: this only tests that the ajax callback gets executed, not the controller response
    xml_http_request :post, :create_report, { :report_variables => { :begda => '2008-01-01', :endda => '2008-12-31', :report_type => 1 } }, { :user_id => users(:fred).id }
    assert_response :success
    assert_template 'create_report'
  end
end
