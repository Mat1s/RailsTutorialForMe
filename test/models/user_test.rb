require 'test_helper'

class UserTest < ActiveSupport::TestCase
  
  def setup
    @user= User.new(name: 'tomas', email: "tomas@go.home", password: "tor32da", password_confirmation: "tor32da")
  end

  test "validates user" do 
    assert @user.valid?
  end
  
  test "name should be not present" do
    @user.name = "       "
    assert_not @user.valid?
  end
  
  test "email should be not present" do
    @user.email = "     "
    assert_not @user.valid?
  end
 
 test "name should not be too long" do
   @user.name = "e"*51
   assert_not @user.valid?
 end
 
 test "email should not to be too long" do
   @user.email = "r"*247 + "@mail.com"
   assert_not @user.valid?
 end
 
 test "email should valid form" do
  adresses = %w[exa,trpe@mail.com lola log@maep)com emaie:l@mail.by cosk.r@oota@mail.re roma@mai+rek kira@smile..con gola@mail,tu]
    adresses.each do |adress_val|
      @user.email = adress_val
      assert_not @user.valid?, "#{adress_val.inspect} should be valid"
    end
  end
  
  test "email must be uniqueness" do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
  end
  
  test "password should be not blank" do
    @user.password = @user.password_confirmation = " "*6
    assert_not @user.valid?
  end
  
  test "password should be minimum 6 digit or str" do
    @user.password = @user.password_confirmation = "r5"*2
    assert_not @user.valid?
  end
  
  test "email addresses should be saved as lower-case" do
    mixed_case_email = "Foo@ExAMPle.CoM"
    @user.email = mixed_case_email
    @user.save
    assert_equal mixed_case_email.downcase, @user.reload.email
  end 
  
  test "authenticated? should return false for a user with nil digest" do
    assert_not @user.authenticated?(:remember, '')
  end
  
  test "associated micropost should be destroy" do
    @user.save
    @user.microposts.create!(content: "Davai do svi..")
    assert_difference 'Micropost.count', -1 do
      @user.destroy
    end
  end
  
  test "should follow and unfollow user" do
    valentino = users(:valentino)
    edison = users(:edison)
    assert_not valentino.following?(edison)
    valentino.follow(edison)
    assert valentino.following?(edison)
    assert edison.followers.include?(valentino)
    valentino.unfollow(edison)
    assert_not valentino.following?(edison)
  end
  
  test "feed should be have right posts" do
    valentino = users(:valentino)
    edison = users(:edison)
    lana = users(:lana)
    
    lana.microposts.each do |post_following|
      assert valentino.feed.include?(post_following)
    end
    
    valentino.microposts.each do |post_self|
      assert valentino.feed.include?(post_self)
    end
    
    edison.microposts.each do |post_unfollowed|
      assert_not valentino.feed.include?(post_unfollowed)
    end
  end
end
