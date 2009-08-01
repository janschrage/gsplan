require 'test_helper'

class AdminControllerTest < ActionController::TestCase

  def test_index
    get :index
    assert_redirected_to :action => "login"
    #assert_equal "Please log in" , flash[:notice]
  end

  def test_login
    fred = users(:fred)
    post :login, :name => fred.name, :password => 'testme'
    #assert_redirected_to :controller => :teamcommitments
    assert_redirected_to :controller => :teamcommitments
    assert_equal fred.id, session[:user_id]
  end

  def test_bad_password
    fred = users(:fred)
    post :login, :name => fred.name, :password => 'wrong'
    assert_template "login"
    assert_equal 'Invalid user/password combination', flash[:notice]
  end

end
