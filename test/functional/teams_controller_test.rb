require 'test_helper'

class TeamsControllerTest < ActionController::TestCase
fixtures :teams, :users, :roles, :rights, :rights_roles, :roles_users

  def test_should_get_index
    get :index, {}, { :user_id => users(:fred).id } 
    assert_response :success
  end

  def test_should_get_new
    get :new, {}, { :user_id => users(:fred).id }
    assert_response :success
  end

  def test_should_create_team
    assert_difference('Team.count') do
      post :create, { :commit => :create, :record => { :name => 'Blue', :description => 'Pink' }}, { :user_id => users(:fred).id }  
    end
    assert_not_nil  assigns(:record)                                                                             
    assert_redirected_to team_path(assigns(:team))
  end

  def test_should_show_team
    get :show, {:id => teams(:one).id}, { :user_id => users(:fred).id }
    assert_response :success
  end

  def test_should_get_edit
    get :edit, {:id => teams(:one).id}, { :user_id => users(:fred).id }
    assert_response :success
  end

  def test_should_update_team
    assert_difference('Team.count', 0) do
      put :update, { :commit => :update, :id => teams(:one).id, :record => {:name => 'Blue', :description => 'Red' }},  { :user_id => users(:fred).id } 
    end
    assert_not_nil  assigns(:record)                                                                             
    team = Team.find(countries(:one).id)                                                                 
    assert_equal  'Red', team.description
    assert_redirected_to team_path(assigns(:team))
  end

  def test_should_destroy_team
    assert_difference('Team.count', -1) do
      delete :destroy, {:id => teams(:one).id}, { :user_id => users(:fred).id }
    end

    assert_redirected_to teams_path
  end
end
