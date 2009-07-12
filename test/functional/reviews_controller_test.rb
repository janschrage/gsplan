require 'test_helper'

class ReviewsControllerTest < ActionController::TestCase
fixtures :reviews, :users, :roles, :rights, :rights_roles, :roles_users

  def test_should_get_index
    get :index, {}, { :user_id => users(:fred).id, :original_uri => '/reviews'  }
    assert_response :success
    assert_not_nil assigns(:reviews)
  end

  def test_should_get_new
    get :new, {}, { :user_id => users(:fred).id, :original_uri => '/reviews' }
    assert_response :success
  end

  def test_should_create_review
    assert_difference('Review.count') do
      post :create, {:review => { :id => 123456, :project_id => 1, :user_id => 1, :notes => 'test', :rtype => 2, :result => 1 }}, { :user_id => users(:fred).id }
    end

    assert_redirected_to review_path(assigns(:review))
  end

  def test_should_show_review
    get :show, {:id => reviews(:one).id{}}, { :user_id => users(:fred).id, :original_uri => '/reviews'   }
    assert_response :success
  end

  def test_should_get_edit
    get :edit, {:id => reviews(:one).id},  { :user_id => users(:fred).id,:original_uri => '/reviews'   }
    assert_response :success
  end

  def test_should_update_review
    put :update, {:id => reviews(:one).id, :review => { :notes => 'test' }}, { :user_id => users(:fred).id,:original_uri => '/reviews'  }
    assert_redirected_to review_path(assigns(:review))
  end

  def test_should_destroy_review
    assert_difference('Review.count', -1) do
      delete :destroy, {:id => reviews(:one).id}, { :user_id => users(:fred).id,:original_uri => '/reviews' }
    end

    assert_redirected_to reviews_path
  end
end
