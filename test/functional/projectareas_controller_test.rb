require 'test_helper'

class ProjectareasControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:projectareas)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_projectarea
    assert_difference('Projectarea.count') do
      post :create, :projectarea => { }
    end

    assert_redirected_to projectarea_path(assigns(:projectarea))
  end

  def test_should_show_projectarea
    get :show, :id => projectareas(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => projectareas(:one).id
    assert_response :success
  end

  def test_should_update_projectarea
    put :update, :id => projectareas(:one).id, :projectarea => { }
    assert_redirected_to projectarea_path(assigns(:projectarea))
  end

  def test_should_destroy_projectarea
    assert_difference('Projectarea.count', -1) do
      delete :destroy, :id => projectareas(:one).id
    end

    assert_redirected_to projectareas_path
  end
end
