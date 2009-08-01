require 'test_helper'

class TeammembersControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index, {}, { :user_id => users(:fred).id }
    assert_response :success
    assert_not_nil assigns(:teammembers)
  end

  def test_should_get_new
    get :new, {}, { :user_id => users(:fred).id }
    assert_response :success
  end

  def test_should_create_teammember
    assert_difference('Teammember.count') do
      post :create, {:teammember => { :employee_id => employees(:one).id, :team_id => teams(:one).id, :begda => '2009-01-01', :endda => '2010-12-31', :percentage => 80 }}, { :user_id => users(:fred).id }
    end

    assert_redirected_to teammember_path(assigns(:teammember))
  end

  def test_should_show_teammember
    get :show, {:id => teammembers(:one).id}, { :user_id => users(:fred).id }
    assert_response :success
  end

  def test_should_get_edit
    get :edit, {:id => teammembers(:one).id}, { :user_id => users(:fred).id }
    assert_response :success
  end

  def test_should_update_teammember
    assert_difference('Teammember.count',0) do
      put :update, {:id => teammembers(:one).id, :teammember => { :employee_id => employees(:one).id, :team_id => teams(:one).id, :begda => '2009-01-01', :endda => '2010-12-31', :percentage => 100 }}, { :user_id => users(:fred).id }
    end
    tm = Teammember.find(teammembers(:one).id)                                                                 
    assert_equal  100, tm.percentage
    assert_redirected_to teammember_path(assigns(:teammember))
  end

  def test_should_destroy_teammember
    assert_difference('Teammember.count', -1) do
      delete :destroy, {:id => teammembers(:one).id}, { :user_id => users(:fred).id }
    end

    assert_redirected_to teammembers_path
  end
end
