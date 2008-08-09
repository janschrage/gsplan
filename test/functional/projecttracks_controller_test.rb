require 'test_helper'

class ProjecttracksControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:projecttracks)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_projecttrack
    assert_difference('Projecttrack.count') do
      post :create, :projecttrack => { }
    end

    assert_redirected_to projecttrack_path(assigns(:projecttrack))
  end

  def test_should_show_projecttrack
    get :show, :id => projecttracks(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => projecttracks(:one).id
    assert_response :success
  end

  def test_should_update_projecttrack
    put :update, :id => projecttracks(:one).id, :projecttrack => { }
    assert_redirected_to projecttrack_path(assigns(:projecttrack))
  end

  def test_should_destroy_projecttrack
    assert_difference('Projecttrack.count', -1) do
      delete :destroy, :id => projecttracks(:one).id
    end

    assert_redirected_to projecttracks_path
  end
end
