require 'test_helper'

class TeamcommitmentsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:teamcommitments)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_teamcommitment
    assert_difference('Teamcommitment.count') do
      post :create, :teamcommitment => { }
    end

    assert_redirected_to teamcommitment_path(assigns(:teamcommitment))
  end

  def test_should_show_teamcommitment
    get :show, :id => teamcommitments(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => teamcommitments(:one).id
    assert_response :success
  end

  def test_should_update_teamcommitment
    put :update, :id => teamcommitments(:one).id, :teamcommitment => { }
    assert_redirected_to teamcommitment_path(assigns(:teamcommitment))
  end

  def test_should_destroy_teamcommitment
    assert_difference('Teamcommitment.count', -1) do
      delete :destroy, :id => teamcommitments(:one).id
    end

    assert_redirected_to teamcommitments_path
  end
end
