require 'test_helper'

class PasswordResetsTest < ActionDispatch::IntegrationTest
  def setup 
    ActionMailer::Base.deliveries.clear
    @user = users(:valentino)
  end
  
  test "password_reset" do
    get new_password_reset_path
    assert_template 'password_resets/new'
    
    post password_resets_path, password_reset: {email: " " }
    assert_not flash.empty?
    assert_template 'password_resets/new'
    # Valid email
    post password_resets_path, password_reset: { email: @user.email }
    assert_not_equal @user.reset_digest, @user.reload.reset_digest
    assert_equal 1, ActionMailer::Base.deliveries.size
    assert_not flash.empty?
    assert_redirected_to root_url
    # Password reset form
    user= assigns(:user)
    # Wrong email
    get edit_password_reset_path(user.reset_token, email: "")
    assert_redirected_to root_url
    # Inactive user
    user.toggle!(:activated)
    get edit_password_reset_path(user.reset_token,email: user.email)
    assert_redirected_to root_url
    user.toggle!(:activated)
    # Right email, wrong token
    get edit_password_reset_path("",email: user.email)
    assert_redirected_to root_url
    #Right email & token
    get edit_password_reset_path(user.reset_token,email: user.email)
    assert_template 'password_resets/edit'
    assert_select "input[name=email][type=hidden][value=?]", user.email
    # Invalid password & confirmation
    patch password_reset_path(user.reset_token),
      email: user.email,
      user: {        password: "efkldsf",
        password_confirmation: "sdfkdfj" }
      assert_select 'div#error_explanation'
    # empty password
    patch password_reset_path(user.reset_token),
      email: user.email,
      user: {        password: "",
        password_confirmation: "" }
      assert_select 'div#error_explanation' 
    # ok reset
    patch password_reset_path(user.reset_token),
      email: user.email,
      user: {        password: "password",
        password_confirmation: "password" }
    assert is_logged_in?
    assert_not flash.empty?
    assert_redirected_to user
  end
  
  test "password_reset_expired" do
    get new_password_reset_path
    post password_resets_path, password_reset: {email: @user.email}
  
    @user = assigns(:user)
    @user.update_attribute(:reset_sent_at, 3.hours.ago)
    patch password_reset_path(@user.reset_token), 
                email: @user.email,
                user: { password: "qwerty12",
                password_confirmation: "qwerty12"}
    assert_response :redirect
    follow_redirect!
    assert_match /Password reset has expired/i, response.body
  end
end
