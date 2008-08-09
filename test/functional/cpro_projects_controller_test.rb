require 'test_helper'

class CproProjectsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:cpro_projects)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_cpro_project
    assert_difference('CproProject.count') do
      post :create, :cpro_project => { }
    end

    assert_redirected_to cpro_project_path(assigns(:cpro_project))
  end

  def test_should_show_cpro_project
    get :show, :id => cpro_projects(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => cpro_projects(:one).id
    assert_response :success
  end

  def test_should_update_cpro_project
    put :update, :id => cpro_projects(:one).id, :cpro_project => { }
    assert_redirected_to cpro_project_path(assigns(:cpro_project))
  end

  def test_should_destroy_cpro_project
    assert_difference('CproProject.count', -1) do
      delete :destroy, :id => cpro_projects(:one).id
    end

    assert_redirected_to cpro_projects_path
  end
end
