require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:valentino)
  end
  
  test "layout_links" do
    get root_path    
    assert_template 'static_pages/home'
    assert_select "a[href=?]", root_path, count: 2
    assert_select "a[href=?]", about_path
    assert_select "a[href=?]", contact_path
    assert_select "a[href=?]", help_path
  end
   
  test "select all in user logged in" do
    log_in_as(@user)
    get user_path(@user)
    assert_template 'users/show'
    assert_select 'a[href=?]', help_path
    assert_select 'a[href=?]', about_path
    assert_select 'a[href=?]', contact_path
    assert_select 'a[href=?]', root_path, count: 2
    assert_select 'a[href=?]', users_path
    assert_select 'a[href=?]', user_path(@user)
    assert_select 'a[href=?]', logout_path
    assert_select 'a[href=?]', edit_user_path(@user)
    assert_select 'a[href=?]', login_path(@user), count: 0
  end 
      
        
  test "select all in user non logged in" do
    get user_path(@user)
    assert_redirected_to root_path
    follow_redirect!
    assert_select 'a[href=?]', help_path
    assert_select 'a[href=?]', about_path
    assert_select 'a[href=?]', contact_path
    assert_select 'a[href=?]', root_path, count: 2
    assert_select 'a[href=?]', users_path, count: 0
    assert_select 'a[href=?]', user_path(@user), count: 0
    assert_select 'a[href=?]', logout_path, count: 0
    assert_select 'a[href=?]', edit_user_path(@user), count: 0
    assert_select 'a[href=?]', login_path
  end
end
