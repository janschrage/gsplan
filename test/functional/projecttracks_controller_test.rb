require 'test_helper'

class ProjecttracksControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index, {}, { :user_id => users(:fred).id }
    assert_response :success
    assert_not_nil assigns(:projecttracks)
  end

  def test_should_get_new
    get :new, {}, { :user_id => users(:fred).id }
    assert_response :success
  end

  def test_should_create_projecttrack
    assert_difference('Projecttrack.count') do
      post :create, {:projecttrack => {  :team_id => 2, :yearmonth => '2008-09-01', :project_id => 4, :reportdate => '2008-09-20', :daysbooked => 1}}, { :user_id => users(:fred).id }
    end
 
    assert_redirected_to projecttrack_path(assigns(:projecttrack))
  end

  def test_should_show_projecttrack
    get :show, {:id => projecttracks(:one).id}, { :user_id => users(:fred).id }
    assert_response :success
  end

  def test_should_get_edit
    get :edit, {:id => projecttracks(:one).id}, { :user_id => users(:fred).id }
    assert_response :success
  end

  def test_should_update_projecttrack
    assert_difference('Projecttrack.count', 0) do
      put :update, {:id => projecttracks(:one).id, :projecttrack => { :team_id => 2, :yearmonth => '2008-09-01', :project_id => 4, :reportdate => '2008-09-20', :daysbooked => 4 }}, { :user_id => users(:fred).id }
    end                                                                          
    pt = Projecttrack.find(projecttracks(:one).id)                                                                 
    assert_equal  4, pt.daysbooked
    assert_redirected_to projecttrack_path(assigns(:projecttrack))
  end

  def test_should_destroy_projecttrack
    assert_difference('Projecttrack.count', -1) do
      delete :destroy, {:id => projecttracks(:one).id}, { :user_id => users(:fred).id }
    end

    assert_redirected_to projecttracks_path
  end
end
