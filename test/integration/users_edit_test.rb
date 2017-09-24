require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  def setup
    @user=users(:valentino)
  end
  
  test "unsuccessfull edit" do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), user: {name: " ", 
                                  email: "rj f;",
                                  password: "pro",
                                  password_confirmation: "re"}
    assert_template 'users/edit'
  end
  
  test "successfull edit with friendly forwarding" do
    get edit_user_path(@user)
    log_in_as(@user)
    assert_redirected_to edit_user_path(@user)
   # assert_template 'users/edit'
    name = "Valenti"
    email = "valio@gmail.com"
    patch user_path(@user), user: {name: name,
                                  email: email,
                                  password: "",
                                  password_confirmation: ""}
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal name, @user.name
    assert_equal email, @user.email
  end
  
  test "should user_path when second login" do
    get edit_user_path(@user)
    log_in_as(@user)
    assert_redirected_to edit_user_path(@user)
    session.delete(:forwarding_url)
    get edit_user_path(@user)
    log_in_as(@user)
    assert_redirected_to user_path(@user)
  end
end
