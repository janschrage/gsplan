require 'test_helper'

class WorktypesControllerTest < ActionController::TestCase
fixtures :worktypes, :users, :roles, :rights, :rights_roles, :roles_users

  def test_should_get_index
    get :index, {}, { :user_id => users(:fred).id }
    assert_response :success
    assert_not_nil assigns(:worktypes)
  end

  def test_should_get_new
    get :new, {}, { :user_id => users(:fred).id }
    assert_response :success
  end

  def test_should_create_worktype
    assert_difference('Worktype.count') do
      post :create, {:worktype => { :id => 12345, :name => 'TX', :description => 'test', :needs_review => false, :preload => true }}, { :user_id => users(:fred).id }
    end

    assert_redirected_to worktype_path(assigns(:worktype))
  end

  def test_should_show_worktype
    get :show, {:id => worktypes(:one).id} #, { :user_id => users(:fred).id }
    assert_response :success
  end

  def test_should_get_edit
    get :edit, {:id => worktypes(:one).id} #, { :user_id => users(:fred).id }
    assert_response :success
  end

  def test_should_update_worktype
    put :update, {:id => worktypes(:one).id, :worktype => { }} , { :user_id => users(:fred).id }
    assert_redirected_to :controller => :teamcommitments, :action => :index
  end

  def test_should_destroy_worktype
    assert_difference('Worktype.count', -1) do
      delete :destroy, {:id => worktypes(:one).id}
    end

    assert_redirected_to worktypes_path
  end
end
