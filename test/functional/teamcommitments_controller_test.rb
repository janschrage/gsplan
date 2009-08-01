require 'test_helper'

class TeamcommitmentsControllerTest < ActionController::TestCase

  def test_should_get_index
    get :index, {}, { :user_id => users(:fred).id }
    assert_response :success
    assert_not_nil assigns(:teamcommitments)
  end

  def test_should_get_new
    get :new, {}, { :user_id => users(:fred).id }
    assert_response :success
  end

  def test_should_create_teamcommitment
    assert_difference('Teamcommitment.count') do
      post :create, { :teamcommitment => { :id => 1234, :team_id => teams(:one).id, :project_id => projects(:one).id, :yearmonth => '2008-08-01', :days => 10, :status => 0 } }, { :user_id => users(:fred).id, :original_uri => teamcommitments_path }
    end
    assert_not_nil assigns(:teamcommitment)
    assert_redirected_to teamcommitments_path
  end

  def test_should_show_teamcommitment
    get :show, {:id => teamcommitments(:one).id}, { :user_id => users(:fred).id }
    assert_response :success
  end

  def test_should_get_edit
    get :edit, {:id => teamcommitments(:one).id}, { :user_id => users(:fred).id }
    assert_response :success
  end

  def test_should_update_teamcommitment
    assert_difference('Teamcommitment.count', 0) do
      put :update, {:id => teamcommitments(:one).id, :teamcommitment => { }}, { :user_id => users(:fred).id, :original_uri => teamcommitments_path }
    end
    assert_not_nil assigns(:teamcommitment)
    assert_redirected_to teamcommitments_path
  end

  def test_should_destroy_teamcommitment
    assert_difference('Teamcommitment.count', -1) do
      delete :destroy, {:id => teamcommitments(:one).id}, { :user_id => users(:fred).id }
    end

    assert_redirected_to teamcommitments_path
  end
end
