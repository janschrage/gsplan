require 'test_helper'

class GraphControllerTest < ActionController::TestCase

  def test_graph_usage
    get :graph_usage, {}, { :user_id => users(:fred).id }
    assert_response :success
  end

  def test_graph_worktypes
    get :graph_worktypes, {}, { :user_id => users(:fred).id }
    assert_response :success
  end

  def test_graph_quintiles
    get :graph_quintiles, {}, { :user_id => users(:fred).id }
    assert_response :success
  end

  def test_graph_planning_delta_in_days
    get :graph_planning_delta_in_days, {}, { :user_id => users(:fred).id }
    assert_response :success
  end

  def test_graph_project_age_current
    get :graph_project_age_current, {}, { :user_id => users(:fred).id }
    assert_response :success
  end

  def test_graph_project_times
    get :graph_project_times, {}, { :user_id => users(:fred).id }, {:report_begda => '2008-01-01', :report_endda => '2009-12-31'}
    assert_response :success
  end

end
