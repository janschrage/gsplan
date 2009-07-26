require 'test_helper'

class CountriesControllerTest < ActionController::TestCase
fixtures :countries, :teams, :users, :roles, :rights, :rights_roles, :roles_users

  def test_should_get_index
    get :index, {}, { :user_id => users(:fred).id } 
    assert_response :success
  end

  def test_should_get_new
    get :new, {}, { :user_id => users(:fred).id }
    assert_response :success
  end

  def test_should_create_country
    assert_difference('Country.count') do
      post :create, { :commit => :create, :record => { :name => 'Nowhereland', :isocode => 'NO', :team_id => teams(:one).id}}, { :user_id => users(:fred).id } 
    end
    assert_not_nil  assigns(:record)                                                                             
    assert_redirected_to country_path(assigns(:country))
  end

  def test_should_show_country
    get :show, {:id => countries(:one).id}, { :user_id => users(:fred).id }
    assert_response :success
  end

  def test_should_get_edit
    get :edit, {:id => countries(:one).id}, { :user_id => users(:fred).id }
    assert_response :success
  end

  def test_should_update_country
    record_no = Country.count
    put :update, {:commit => :update, :id => countries(:one).id, :record => { :name => 'Nowhereland', :isocode => 'NW', :team_id => teams(:one).id }}, { :user_id => users(:fred).id }
    assert_not_nil  assigns(:record)                                                                             
    assert_equal record_no, Country.count                                                                       
    country = Country.find(countries(:one).id)                                                                 
    assert_equal  'NW', country.isocode
    assert_redirected_to country_path(assigns(:country))
  end

  def test_should_destroy_country
    assert_difference('Country.count', -1) do
      delete :destroy, {:id => countries(:one).id}, { :user_id => users(:fred).id }
    end

    assert_redirected_to countries_path
  end
end
