require 'test_helper'

class RelationshipsControllerTest < ActionController::TestCase
  
  test "should redirect create relationships when not logged_in" do
    assert_no_difference 'Relationship.count' do
      post :create
    end
    assert_redirected_to login_url
  end
  
  test "should redirect delete relationships when not logged_in" do
    assert_no_difference 'Relationship.count' do
      delete :destroy, id: relationships(:one)
    end
    assert_redirected_to login_url
  end
end
