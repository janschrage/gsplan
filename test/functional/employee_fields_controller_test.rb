require 'test_helper'

class EmployeeFieldsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:employee_fields)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_employee_fields
    assert_difference('EmployeeFields.count') do
      post :create, :employee_fields => { }
    end

    assert_redirected_to employee_fields_path(assigns(:employee_fields))
  end

  def test_should_show_employee_fields
    get :show, :id => employee_fields(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => employee_fields(:one).id
    assert_response :success
  end

  def test_should_update_employee_fields
    put :update, :id => employee_fields(:one).id, :employee_fields => { }
    assert_redirected_to employee_fields_path(assigns(:employee_fields))
  end

  def test_should_destroy_employee_fields
    assert_difference('EmployeeFields.count', -1) do
      delete :destroy, :id => employee_fields(:one).id
    end

    assert_redirected_to employee_fields_path
  end
end
