require 'test_helper'

class WorktypesControllerTest < ActionController::TestCase

  def test_should_get_index
    get :index, {}, { :user_id => users(:fred).id }
    assert_response :success
  end

  def test_should_get_new
    get :new, {}, { :user_id => users(:fred).id }
    assert_response :success
  end

  def test_should_create_worktype
    assert_difference('Worktype.count') do
      post :create, {:commit => :create, :record => { :name => 'TX', :description => 'test', :needs_review => false, :preload => true, :is_continuous => false }}, { :user_id => users(:fred).id }
    end
    assert_not_nil  assigns(:record)   
    assert_redirected_to worktype_path(assigns(:worktype))
  end

  def test_should_show_worktype
    get :show, {:id => worktypes(:one).id}, { :user_id => users(:fred).id }
    assert_response :success
  end

  def test_should_get_edit
    get :edit, {:id => worktypes(:one).id}, { :user_id => users(:fred).id }
    assert_response :success
  end

  def test_should_update_worktype
    record_no = Worktype.count
    put :update, {:commit => :update, :id => worktypes(:one).id, :record => { :name => 'TX', :description => 'test update', :needs_review => false,:preload => true, :is_continuous => false }} , { :user_id => users(:fred).id }
    assert_not_nil  assigns(:record)
    assert_equal record_no, Worktype.count
    worktype = Worktype.find(worktypes(:one).id)
    assert_equal  'test update', worktype.description
    assert_redirected_to worktypes_path
  end

  def test_should_destroy_worktype
    assert_difference('Worktype.count', -1) do
      delete :destroy, {:id => worktypes(:one).id},  { :user_id => users(:fred).id }
    end

    assert_redirected_to worktypes_path
  end
end
