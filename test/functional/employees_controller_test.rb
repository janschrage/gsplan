require 'test_helper'

class EmployeesControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index, {}, { :user_id => users(:fred).id }
    assert_response :success
  end

  def test_should_get_new
    get :new, {}, { :user_id => users(:fred).id }
    assert_response :success
  end

  def test_should_create_employee
    assert_difference('Employee.count') do
      post :create, {:commit => :create, :record => { :name => 'hardy', :pernr => '834792', :is_reviewer => false }}, { :user_id => users(:fred).id }
    end
    assert_not_nil  assigns(:record)                                                                             
#    assert_redirected_to employee_path(assigns(:employee))
  end

  def test_should_show_employee
    get :show, {:id => employees(:one).id}, { :user_id => users(:fred).id }
    assert_response :success
  end

  def test_should_get_edit
    get :edit, {:id => employees(:one).id}, { :user_id => users(:fred).id }
    assert_response :success
  end

  def test_should_update_employee
    assert_difference('Employee.count',0) do
      put :update, {:commit => :update, :id => employees(:one).id, :record => { :name => 'barney', :pernr => 'I123456', :is_reviewer => true }}, { :user_id => users(:fred).id }
    end
    assert_not_nil  assigns(:record)                                                                             
    employee = Employee.find(employees(:one).id)                                                                 
    assert_equal  true, employee.is_reviewer
#    assert_redirected_to employee_path(assigns(:employee))
  end

  def test_should_destroy_employee
    assert_difference('Employee.count', -1) do
      delete :destroy, {:id => employees(:one).id}, { :user_id => users(:fred).id }
    end

 #   assert_redirected_to employees_path
  end
end
