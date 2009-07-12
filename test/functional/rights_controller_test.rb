require 'test_helper'

class RightsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index, {}, { :user_id => users(:fred).id }
    assert_response :success
    assert_not_nil assigns(:rights)
  end

  def test_should_get_new
    get :new,{}, { :user_id => users(:fred).id }
    assert_response :success
  end

  def test_should_create_right
    assert_difference('Right.count') do
      post :create, {:right => { }}, { :user_id => users(:fred).id }
    end

    assert_redirected_to right_path(assigns(:right))
  end

  def test_should_show_right
    get :show, {:id => rights(:one).id}, { :user_id => users(:fred).id }
    assert_response :success
  end

  def test_should_get_edit
    get :edit, {:id => rights(:one).id}, { :user_id => users(:fred).id }
    assert_response :success
  end

  def test_should_update_right
    put :update,{ :id => rights(:one).id, :right => { }}, { :user_id => users(:fred).id }
    assert_redirected_to right_path(assigns(:right))
  end

  def test_should_destroy_right
    assert_difference('Right.count', -1) do
      delete :destroy, {:id => rights(:one).id}, { :user_id => users(:fred).id }
    end

    assert_redirected_to rights_path
  end
end
