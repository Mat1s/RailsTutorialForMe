require 'test_helper'

class RelationshipTest < ActiveSupport::TestCase
  
  def setup
    @relationships = Relationship.new(follower_id: 1, followed_id: 2)
  end
  
  test "should be valid" do
    assert @relationships.valid?
  end
  
  test "should require follower_id" do
    @relationships.follower_id = nil
    assert_not @relationships.valid?
  end
  
  test "should require followed_id" do
    @relationships.followed_id = nil
    assert_not @relationships.valid?
  end
end
