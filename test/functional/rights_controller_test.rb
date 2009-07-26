require 'test_helper'

class RightsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index, {}, { :user_id => users(:fred).id }
    assert_response :success
  end

  def test_should_get_new
    get :new,{}, { :user_id => users(:fred).id }
    assert_response :success
  end

  def test_should_create_right
    assert_difference('Right.count') do
      post :create, { :commit => :create, :record => { :name => 'all', :controller => '*', :action => '*'}}, { :user_id => users(:fred).id }
    end
    assert_not_nil  assigns(:record)                                                                             
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
    assert_difference('Right.count', 0) do    
      put :update,{ :commit => :update, :id => rights(:one).id, :record => { :name => 'test', :controller => 'test', :action => '*'}}, { :user_id => users(:fred).id }
    end
    assert_not_nil  assigns(:record)                                                                             
    right = Right.find(rights(:one).id)                                                                 
    assert_equal  'test', right.controller
    assert_redirected_to right_path(assigns(:right))
  end

  def test_should_destroy_right
    assert_difference('Right.count', -1) do
      delete :destroy, {:id => rights(:one).id}, { :user_id => users(:fred).id }
    end

    assert_redirected_to rights_path
  end
end
