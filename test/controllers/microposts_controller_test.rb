require 'test_helper'

class MicropostsControllerTest < ActionController::TestCase
 
  def setup
    @micropost = microposts(:orange)
  end
  
  test "should redirect if create m if not logged_in" do
    assert_no_difference 'Micropost.count' do
      post :create, micropost: { content: "Ne poluchittca" }
    end
    assert_redirected_to login_url
  end
  
  test "should redirect if destroy m if not logged_in" do 
    assert_no_difference 'Micropost.count' do
      delete :destroy, id: @micropost
    end
    assert_redirected_to login_url
  end
  
  test "post other user not delete" do
    log_in_as(users(:valentino))
    micropost = microposts(:ants)
    assert_no_difference 'Micropost.count' do
      delete :destroy, id: micropost
    end
    assert_redirected_to root_url
  end
  
end
