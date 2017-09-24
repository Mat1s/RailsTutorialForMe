require 'test_helper'

class MicropostTest < ActiveSupport::TestCase
  def setup
    @user = users(:valentino)
    @micropost = @user.microposts.build( content: "First micropost")
  end
   
  test "should be valid" do
    assert @micropost.valid?
  end
   
  test "user id must be present" do
    @micropost.user_id = nil
    assert_not @micropost.valid?
  end
  
  test "content micropost is not empty" do
    @micropost.content = ""
    assert_not @micropost.valid?
  end
  
  test "content is less 141 characters" do
    @micropost.content = "a"*141
    assert_not @micropost.valid?
  end
  
  test "order should be most recent first" do 
    assert_equal microposts(:most_recent), Micropost.first
  end
end
