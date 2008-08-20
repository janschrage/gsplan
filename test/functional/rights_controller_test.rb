require 'test_helper'

class RightsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:rights)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_right
    assert_difference('Right.count') do
      post :create, :right => { }
    end

    assert_redirected_to right_path(assigns(:right))
  end

  def test_should_show_right
    get :show, :id => rights(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => rights(:one).id
    assert_response :success
  end

  def test_should_update_right
    put :update, :id => rights(:one).id, :right => { }
    assert_redirected_to right_path(assigns(:right))
  end

  def test_should_destroy_right
    assert_difference('Right.count', -1) do
      delete :destroy, :id => rights(:one).id
    end

    assert_redirected_to rights_path
  end
end
