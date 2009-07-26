require 'test_helper'

class ProjectareasControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index, {}, { :user_id => users(:fred).id }
    assert_response :success
  end

  def test_should_get_new
    get :new, {}, { :user_id => users(:fred).id }
    assert_response :success
  end

  def test_should_create_projectarea
    assert_difference('Projectarea.count') do
      post :create,{ :projectarea => { :area => 'test23' }}, { :user_id => users(:fred).id }
    end

    assert_not_nil assigns(:projectarea)
    assert_redirected_to projectarea_path(assigns(:projectarea))
  end

  def test_should_show_projectarea
    get :show, {:id => projectareas(:one).id}, { :user_id => users(:fred).id }
    assert_response :success
  end

  def test_should_get_edit
    get :edit, {:id => projectareas(:one).id}, { :user_id => users(:fred).id }
    assert_response :success
  end

  def test_should_update_projectarea
    assert_difference('Projectarea.count',0) do
      put :update, {:id => projectareas(:one).id, :projectarea => { :area => 'test73' }}, { :user_id => users(:fred).id }
    end
    assert_not_nil  assigns(:projectarea)                                                                             
    pa = Projectarea.find(projectareas(:one).id)                                                                 
    assert_equal  'test73', pa.area
    assert_redirected_to projectarea_path(assigns(:projectarea))
  end

  def test_should_destroy_projectarea
    assert_difference('Projectarea.count', -1) do
      delete :destroy, {:id => projectareas(:one).id}, { :user_id => users(:fred).id }
    end

    assert_redirected_to projectareas_path
  end
end
