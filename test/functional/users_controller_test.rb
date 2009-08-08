require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index, {}, { :user_id => users(:fred).id }
    assert_response :success
    assert_not_nil assigns(:users)
  end

  def test_should_get_new
    get :new, {}, { :user_id => users(:fred).id }
    assert_response :success
  end

  def test_should_create_user
    assert_difference('User.count') do
      post :create, { :user => { :name => 'testcreate', :password => 'testpw' } }, { :user_id => users(:fred).id }
    end
    assert_not_nil assigns(:user)
    uid = User.find_by_name('testcreate').id
    assert_redirected_to :action => :assign_roles, :params => {:id => uid }
  end

  def test_should_show_user
    get :show, {:id => users(:one).id}, { :user_id => users(:fred).id }
    assert_response :success
  end

  def test_should_get_assign_roles
    get :assign_roles, { :id => users(:fred).id }, { :user_id => users(:fred).id }
    assert_response :success
  end

  def test_should_get_edit
    get :edit, {:id => users(:one).id},{ :user_id => users(:fred).id }
    assert_response :success
  end

  def test_should_update_user
    assert_difference('User.count', 0) do
      put :update, {:id => users(:one).id, :user => { :id => users(:one).id, :name => 'testupdate', :password => 'testpw' }},{ :user_id => users(:fred).id, :original_uri => users_path }
    end
    assert_not_nil assigns(:user)
    user = User.find(users(:one).id)                                                                 
    assert_equal  'testupdate', user.name
    assert_redirected_to users_path
  end

  def test_should_destroy_user
    assert_difference('User.count', -1) do
      delete :destroy, {:id => users(:one).id},{ :user_id => users(:fred).id }
    end

    assert_redirected_to users_path
  end
end
