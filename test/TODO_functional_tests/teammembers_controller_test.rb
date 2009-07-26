require 'test_helper'

class TeammembersControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:teammembers)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_teammember
    assert_difference('Teammember.count') do
      post :create, :teammember => { }
    end

    assert_redirected_to teammember_path(assigns(:teammember))
  end

  def test_should_show_teammember
    get :show, :id => teammembers(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => teammembers(:one).id
    assert_response :success
  end

  def test_should_update_teammember
    put :update, :id => teammembers(:one).id, :teammember => { }
    assert_redirected_to teammember_path(assigns(:teammember))
  end

  def test_should_destroy_teammember
    assert_difference('Teammember.count', -1) do
      delete :destroy, :id => teammembers(:one).id
    end

    assert_redirected_to teammembers_path
  end
end
