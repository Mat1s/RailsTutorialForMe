require 'test_helper'

class MicropostsInterfaceTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:valentino)
    @other_user = users(:edison)
  end
  
  test "microposts interface" do
    log_in_as(@user)
    get root_path
    assert_select 'div.pagination'
    assert_select 'input[type=file]'
    #invalid submissions
    assert_no_difference 'Micropost.count' do
      post microposts_path micropost: {content: "" }
    end
    assert_select 'div#error_explanation'
    
    #valid submissions
    content = "valid information"
    picture = fixture_file_upload('test/fixtures/rails.png', 'image/png')
    #picture = Rack::Test::UploadedFile.new(File.join(ActionController::TestCase.fixture_path, 'test/fixtures/dima.jpg'), 'image/jpg')
    assert_difference 'Micropost.count', 1 do
      post microposts_path micropost: {content: content, picture: picture }
    end
    #!!!!micropost = assigns(:micropost)
    #!!!!assert micropost.picture?
    assert_redirected_to root_url
    #assert @user.microposts.find_by(content: content).picture?
    follow_redirect!
    assert_match content, response.body
    
    #delete a post
    assert_select 'a', text: 'delete'
    first_micropost = @user.microposts.paginate(page: 1).first
    assert_difference 'Micropost.count', -1 do
      delete micropost_path(first_micropost)
    end
    
    #visit other user
    
    get user_path(@other_user)
    assert_select 'a', text: 'delete', count: 0
    assert_no_difference 'Micropost.count' do
      delete micropost_path(@other_user.microposts.paginate(page: 1).first)
    end
  end
  
  test "micropost sidebar count" do
    log_in_as(@user)
    get root_path
    assert_match "#{@user.microposts.count} microposts", response.body
    
    other_user = users(:mallory)
    log_in_as(other_user)
    get root_path
    assert_match "0 microposts", response.body
    other_user.microposts.create!(content: "the first m")
    get root_path 
    assert_match other_user.microposts.first.content , response.body
  end
end
