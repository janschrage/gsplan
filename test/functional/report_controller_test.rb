require 'test_helper'

class ReportControllerTest < ActionController::TestCase

  def test_should_get_index
    get :index, {}, { :user_id => users(:fred).id }
    assert_response :success
  end
end
