require 'test_helper'

class ProjectsControllerTest < ActionController::TestCase
fixtures :users, :roles, :rights, :rights_roles, :roles_users

  def test_should_get_index
    get :index,{}, { :user_id => users(:fred).id }
    assert_response :success
    assert_not_nil assigns(:projects)
  end

  def test_should_get_new
    get :new,{}, { :user_id => users(:fred).id }
    assert_response :success
  end

  def test_should_create_project
    assert_difference('Project.count') do
      post :create, {:project => { :id => 123346, :employee_id => 1, :worktype_id => 1, :planbeg => '2000-01-01'.to_date, :planend => '2000-12-31'.to_date, :planeffort => 100, :name => 'Huge Project', :country_id => 1 }}, { :user_id => users(:fred).id, :original_uri => '/projects'}
    end

    assert_redirected_to '/projects'
    assert assigns(:project)
  end

  def test_should_show_project
    get :show, {:id => projects(:one).id}, { :user_id => users(:fred).id }
    assert_response :success
  end

  def test_should_get_edit
    get :edit, {:id => projects(:one).id}, { :user_id => users(:fred).id }
    assert_response :success
  end

  def test_should_update_project
    put :update, {:id => projects(:one).id, :project => { :planeffort => 10 }},{ :user_id => users(:fred).id, :original_uri => '/projects' }
    assert assigns(:project)
    assert_redirected_to '/projects'
  end

  def test_should_destroy_project
    assert_difference('Project.count', -1) do
      delete :destroy, {:id => projects(:one).id}, { :user_id => users(:fred).id }
    end

    assert_redirected_to projects_path
  end
end
